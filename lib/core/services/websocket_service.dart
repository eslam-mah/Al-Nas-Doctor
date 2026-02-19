import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alnas_doctor/core/services/http_service/dio_helper.dart';
import 'package:alnas_doctor/features/chat/data/models/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket service for real-time chat communication.
///
/// Usage:
/// ```dart
/// final wsService = WebSocketService();
/// await wsService.connect();
/// wsService.messageStream.listen((message) { ... });
/// wsService.sendMessage(messageModel);
/// wsService.disconnect();
/// ```
class WebSocketService {
  static const String _wsBaseUrl = 'wss://ras.alnaseg.dynv6.net:4430/ws';

  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _intentionalDisconnect = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _initialReconnectDelay = Duration(seconds: 3);

  /// Stream controller for incoming messages
  final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();

  /// Stream controller for connection status
  final StreamController<WebSocketConnectionStatus>
  _connectionStatusController =
      StreamController<WebSocketConnectionStatus>.broadcast();

  /// Stream of incoming messages
  Stream<MessageModel> get messageStream => _messageController.stream;

  /// Stream of connection status changes
  Stream<WebSocketConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  /// Whether the WebSocket is currently connected
  bool get isConnected => _isConnected;

  /// Connect to the WebSocket server
  Future<void> connect() async {
    if (_isConnected) {
      if (kDebugMode) {
        debugPrint('WebSocket: Already connected');
      }
      return;
    }

    _intentionalDisconnect = false;

    try {
      _connectionStatusController.add(WebSocketConnectionStatus.connecting);

      final token = await DioHelper.getToken();
      if (token == null || token.isEmpty) {
        if (kDebugMode) {
          debugPrint('WebSocket: No auth token available');
        }
        _connectionStatusController.add(WebSocketConnectionStatus.error);
        return;
      }

      final wsUrl = Uri.parse('$_wsBaseUrl?token=$token');

      if (kDebugMode) {
        debugPrint('WebSocket: Connecting to $wsUrl');
      }

      // Create a custom HttpClient that bypasses SSL (dev only)
      final httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

      _channel = IOWebSocketChannel.connect(
        wsUrl,
        // The built-in pingInterval handles keep-alive automatically.
        // No need for a separate manual ping timer.
        pingInterval: const Duration(seconds: 30),
        customClient: httpClient,
      );

      // Wait for connection to be established
      await _channel!.ready;

      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionStatusController.add(WebSocketConnectionStatus.connected);

      if (kDebugMode) {
        debugPrint('WebSocket: Connected successfully');
      }

      // Listen for incoming messages
      _channel!.stream.listen(
        _onMessageReceived,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('WebSocket: Connection error - $e');
      }
      _isConnected = false;
      _connectionStatusController.add(WebSocketConnectionStatus.error);
      _scheduleReconnect();
    }
  }

  /// Send a message through the WebSocket
  void sendMessage(MessageModel message) {
    if (!_isConnected || _channel == null) {
      if (kDebugMode) {
        debugPrint('WebSocket: Cannot send message - not connected');
      }
      return;
    }

    try {
      final jsonStr = jsonEncode(message.toJson());
      _channel!.sink.add(jsonStr);
      if (kDebugMode) {
        debugPrint('WebSocket: Message sent - $jsonStr');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('WebSocket: Error sending message - $e');
      }
    }
  }

  /// Disconnect from the WebSocket server intentionally
  Future<void> disconnect() async {
    _intentionalDisconnect = true;
    _reconnectTimer?.cancel();

    if (_channel != null) {
      try {
        await _channel!.sink.close();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('WebSocket: Error closing connection - $e');
        }
      }
    }

    _isConnected = false;
    _channel = null;
    _connectionStatusController.add(WebSocketConnectionStatus.disconnected);

    if (kDebugMode) {
      debugPrint('WebSocket: Disconnected intentionally');
    }
  }

  /// Dispose resources
  void dispose() {
    _intentionalDisconnect = true;
    _reconnectTimer?.cancel();

    if (_channel != null) {
      try {
        _channel!.sink.close();
      } catch (_) {}
    }

    _isConnected = false;
    _channel = null;
    _messageController.close();
    _connectionStatusController.close();
  }

  // ============================================
  // PRIVATE METHODS
  // ============================================

  void _onMessageReceived(dynamic data) {
    try {
      if (kDebugMode) {
        debugPrint('WebSocket: Message received - $data');
      }

      if (data is String) {
        final Map<String, dynamic> jsonData = jsonDecode(data);

        // Ignore server-side ping/pong frames
        if (jsonData.containsKey('type') &&
            (jsonData['type'] == 'ping' || jsonData['type'] == 'pong')) {
          return;
        }

        final message = MessageModel.fromJson(jsonData);
        _messageController.add(message);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('WebSocket: Error parsing message - $e');
      }
    }
  }

  void _onError(dynamic error) {
    if (kDebugMode) {
      debugPrint('WebSocket: Stream error - $error');
    }
    _isConnected = false;
    _connectionStatusController.add(WebSocketConnectionStatus.error);

    // Only reconnect if it wasn't an intentional disconnect
    if (!_intentionalDisconnect) {
      _scheduleReconnect();
    }
  }

  void _onDone() {
    if (kDebugMode) {
      debugPrint(
        'WebSocket: Connection closed (intentional: $_intentionalDisconnect)',
      );
    }
    _isConnected = false;

    // Only reconnect if it wasn't an intentional disconnect
    if (!_intentionalDisconnect) {
      _connectionStatusController.add(WebSocketConnectionStatus.disconnected);
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_intentionalDisconnect) return;

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) {
        debugPrint('WebSocket: Max reconnect attempts reached');
      }
      _connectionStatusController.add(WebSocketConnectionStatus.failed);
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    // Exponential backoff: 3s, 6s, 9s, 12s, 15s
    final delay = _initialReconnectDelay * _reconnectAttempts;
    if (kDebugMode) {
      debugPrint(
        'WebSocket: Scheduling reconnect in ${delay.inSeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)',
      );
    }

    _connectionStatusController.add(WebSocketConnectionStatus.reconnecting);

    _reconnectTimer = Timer(delay, () {
      if (!_intentionalDisconnect) {
        connect();
      }
    });
  }
}

/// Enum to represent WebSocket connection status
enum WebSocketConnectionStatus {
  connecting,
  connected,
  disconnected,
  reconnecting,
  error,
  failed,
}
