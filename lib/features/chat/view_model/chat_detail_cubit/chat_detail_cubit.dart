import 'dart:async';

import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/core/services/websocket_service.dart';
import 'package:alnas_doctor/features/chat/data/models/message_model.dart';
import 'package:alnas_doctor/features/chat/data/repos/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_detail_state.dart';

class ChatDetailCubit extends Cubit<ChatDetailState> {
  ChatDetailCubit({
    required this.chatId,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
  }) : super(ChatDetailInitial());

  final int chatId;
  final int patientId;
  final int doctorId;
  final String patientName;

  final ChatRepo _chatRepo = ChatRepo();
  final WebSocketService _webSocketService = WebSocketService();
  final List<MessageModel> _messages = [];

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<WebSocketConnectionStatus>? _statusSubscription;

  int get _currentUserId => UserSession.instance.userData?.id ?? doctorId;
  String get _currentUserType => 'doctor';

  /// Initialize the chat: load history from API, then connect WebSocket
  Future<void> initChat() async {
    if (isClosed) return;

    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════════════════');
      debugPrint('ChatDetailCubit: Entering chat ID: $chatId');
      debugPrint(
        'ChatDetailCubit: Patient ID: $patientId, Doctor ID: $doctorId',
      );
      debugPrint(
        'ChatDetailCubit: Current User ID: $_currentUserId, Type: $_currentUserType',
      );
      debugPrint('═══════════════════════════════════════════════════');
    }

    emit(ChatDetailLoading());

    // 1. Load chat history from API
    await _loadChatHistory();

    // 2. Listen to connection status
    _statusSubscription?.cancel();
    _statusSubscription = _webSocketService.connectionStatusStream.listen(
      _onConnectionStatusChange,
    );

    // 3. Listen to incoming messages
    _messageSubscription?.cancel();
    _messageSubscription = _webSocketService.messageStream.listen(
      _onMessageReceived,
    );

    // 4. Connect WebSocket
    await _webSocketService.connect();
  }

  /// Fetch existing messages from the chat_messages API
  Future<void> _loadChatHistory() async {
    if (kDebugMode) {
      debugPrint(
        'ChatDetailCubit: Loading chat history for chat $chatId via HTTP',
      );
    }

    final result = await _chatRepo.getChatMessages(chatId: chatId);

    result.fold(
      (failure) {
        if (kDebugMode) {
          debugPrint(
            'ChatDetailCubit: Failed to load chat history - ${failure.message}',
          );
        }
      },
      (messages) {
        if (isClosed) return;
        _messages.clear();
        _messages.addAll(messages);
        // Sort by created_at ascending (oldest first)
        _messages.sort(
          (a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''),
        );

        if (kDebugMode) {
          debugPrint(
            'ChatDetailCubit: Loaded ${_messages.length} messages from HTTP',
          );
        }

        if (_messages.isNotEmpty) {
          emit(ChatDetailMessageReceived(messages: List.from(_messages)));
        }
      },
    );
  }

  /// Handle connection status changes
  void _onConnectionStatusChange(WebSocketConnectionStatus status) {
    if (isClosed) return;

    switch (status) {
      case WebSocketConnectionStatus.connecting:
        if (_messages.isEmpty) {
          emit(ChatDetailLoading());
        }
        break;
      case WebSocketConnectionStatus.connected:
        _joinChat();
        emit(ChatDetailConnected(messages: List.from(_messages)));
        break;
      case WebSocketConnectionStatus.reconnecting:
        emit(ChatDetailReconnecting(messages: List.from(_messages)));
        break;
      case WebSocketConnectionStatus.disconnected:
        emit(ChatDetailDisconnected(messages: List.from(_messages)));
        break;
      case WebSocketConnectionStatus.error:
        // Keep the current messages visible while attempting to reconnect
        break;
      case WebSocketConnectionStatus.failed:
        emit(
          ChatDetailConnectionError(
            messages: List.from(_messages),
            error: 'Failed to connect after multiple attempts',
          ),
        );
        break;
    }
  }

  /// Tell the server which chat room this client wants to join
  void _joinChat() {
    if (kDebugMode) {
      debugPrint('ChatDetailCubit: Joining chat $chatId');
    }
    _webSocketService.sendMessage({
      'type': 'join',
      'chat_id': chatId,
      'sender_id': _currentUserId,
      'sender_type': _currentUserType,
    });
  }

  /// Handle incoming messages from the WebSocket
  void _onMessageReceived(Map<String, dynamic> data) {
    if (isClosed) return;

    if (kDebugMode) {
      debugPrint('ChatDetailCubit: Received message data: $data');
    }

    final String? type = data['type']?.toString();

    switch (type) {
      case 'ping':
      case 'pong':
        // Ping/pong response, ignore
        break;
      case 'history':
        // Server sent chat history (WebSocket-based history)
        _handleHistory(data);
        break;
      case 'error':
        if (kDebugMode) {
          debugPrint('ChatDetailCubit: Server error - ${data['message']}');
        }
        break;
      case 'joined':
      case 'left':
      case 'ack':
      case 'sent':
        // Server acknowledgments, ignore
        if (kDebugMode) {
          debugPrint('ChatDetailCubit: Server ack type=$type, ignoring');
        }
        break;
      default:
        // Only treat as a chat message if it actually contains message content
        _handleIncomingMessage(data);
        break;
    }
  }

  /// Handle chat history received from the WebSocket server
  void _handleHistory(Map<String, dynamic> data) {
    final List? historyList = data['messages'] as List?;
    if (historyList != null) {
      _messages.clear();
      for (final msg in historyList) {
        if (msg is Map<String, dynamic>) {
          _messages.add(MessageModel.fromJson(msg));
        }
      }
      // Sort by created_at ascending (oldest first)
      _messages.sort(
        (a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''),
      );

      if (kDebugMode) {
        debugPrint(
          'ChatDetailCubit: WS history loaded ${_messages.length} messages',
        );
      }

      if (!isClosed) {
        emit(ChatDetailMessageReceived(messages: List.from(_messages)));
      }
    }
  }

  /// Handle a single incoming message
  void _handleIncomingMessage(Map<String, dynamic> data) {
    // Skip data that doesn't contain actual message content
    // (server acks, status updates, etc.)
    final messageText = data['message']?.toString();
    if (messageText == null || messageText.trim().isEmpty) {
      if (kDebugMode) {
        debugPrint('ChatDetailCubit: Skipping non-message data: $data');
      }
      return;
    }

    // Only process messages that belong to this chat
    final msgChatId = _parseToInt(data['chat_id']);
    if (msgChatId != null && msgChatId != chatId) {
      if (kDebugMode) {
        debugPrint(
          'ChatDetailCubit: Ignoring message for chat $msgChatId (current: $chatId)',
        );
      }
      return;
    }

    final message = MessageModel.fromJson(data);

    // Avoid duplicate messages
    final isDuplicate = _messages.any((m) {
      // Check by message_id / id (both non-null)
      if (m.id != null && message.id != null) {
        return m.id == message.id;
      }
      // Fallback: match by content + sender (catches optimistic sends
      // where local message has no id yet but server echo does)
      if (m.message == message.message && m.senderId == message.senderId) {
        // If either has no createdAt, still treat as duplicate
        if (m.createdAt == null || message.createdAt == null) return true;
        return _timeDiffSeconds(m.createdAt!, message.createdAt!) < 5;
      }
      return false;
    });

    if (isDuplicate) {
      if (kDebugMode) {
        debugPrint('ChatDetailCubit: Skipping duplicate message');
      }
      return;
    }

    _messages.add(message);

    if (!isClosed) {
      emit(ChatDetailMessageReceived(messages: List.from(_messages)));
    }
  }

  /// Calculate time difference in seconds between two date strings
  int _timeDiffSeconds(String dateStr1, String dateStr2) {
    try {
      final d1 = DateTime.parse(dateStr1);
      final d2 = DateTime.parse(dateStr2);
      return d1.difference(d2).inSeconds.abs();
    } catch (_) {
      return 999; // not duplicates if we can't parse
    }
  }

  /// Safely parse a dynamic value to int
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  /// Send a text message
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final messageData = {
      'chat_id': chatId,
      'sender_id': _currentUserId,
      'sender_type': _currentUserType,
      'receiver_id': patientId,
      'receiver_type': 'patient',
      'message': text.trim(),
      'message_type': 'text',
    };

    // Add to local list immediately for optimistic UI
    final message = MessageModel(
      chatId: chatId,
      senderId: _currentUserId,
      senderType: _currentUserType,
      receiverId: patientId,
      receiverType: 'patient',
      message: text.trim(),
      messageType: 'text',
      createdAt: DateTime.now().toIso8601String(),
    );

    _messages.add(message);
    if (!isClosed) {
      emit(ChatDetailMessageSent(messages: List.from(_messages)));
    }

    // Send via WebSocket
    _webSocketService.sendMessage(messageData);
  }

  /// Retry connection
  Future<void> retryConnection() async {
    _messageSubscription?.cancel();
    _statusSubscription?.cancel();
    await _webSocketService.disconnect();
    await initChat();
  }

  @override
  Future<void> close() async {
    _messageSubscription?.cancel();
    _statusSubscription?.cancel();
    await _webSocketService.dispose();
    return super.close();
  }
}
