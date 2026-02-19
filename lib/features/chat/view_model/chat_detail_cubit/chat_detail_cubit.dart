import 'dart:async';

import 'package:alnas_doctor/core/services/websocket_service.dart';
import 'package:alnas_doctor/features/chat/data/models/message_model.dart';
import 'package:equatable/equatable.dart';
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

  final WebSocketService _webSocketService = WebSocketService();
  final List<MessageModel> _messages = [];
  StreamSubscription<MessageModel>? _messageSubscription;
  StreamSubscription<WebSocketConnectionStatus>? _statusSubscription;

  /// Initialize the chat: connect WebSocket
  /// (Chat history API not available yet – will be added later)
  Future<void> initChat() async {
    if (isClosed) return;
    emit(ChatDetailLoading());

    // Connect WebSocket
    await _connectWebSocket();
  }

  /// Connect to WebSocket and listen for messages
  Future<void> _connectWebSocket() async {
    // Listen for connection status
    _statusSubscription = _webSocketService.connectionStatusStream.listen((
      status,
    ) {
      if (isClosed) return;

      switch (status) {
        case WebSocketConnectionStatus.connected:
          emit(ChatDetailConnected(messages: List.from(_messages)));
          break;
        case WebSocketConnectionStatus.connecting:
          if (_messages.isEmpty) {
            emit(ChatDetailLoading());
          } else {
            emit(ChatDetailReconnecting(messages: List.from(_messages)));
          }
          break;
        case WebSocketConnectionStatus.reconnecting:
          emit(ChatDetailReconnecting(messages: List.from(_messages)));
          break;
        case WebSocketConnectionStatus.disconnected:
          emit(ChatDetailDisconnected(messages: List.from(_messages)));
          break;
        case WebSocketConnectionStatus.error:
          emit(
            ChatDetailConnectionError(
              messages: List.from(_messages),
              error: 'Connection error occurred',
            ),
          );
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
    });

    // Listen for incoming messages
    _messageSubscription = _webSocketService.messageStream.listen((message) {
      if (isClosed) return;

      // Only add messages that belong to this chat
      if (message.chatId == chatId) {
        _messages.add(message);
        emit(ChatDetailMessageReceived(messages: List.from(_messages)));
      }
    });

    // Connect
    await _webSocketService.connect();

    // If WebSocket connected but we already have messages, emit them
    if (isClosed) return;
    if (_messages.isNotEmpty && _webSocketService.isConnected) {
      emit(ChatDetailConnected(messages: List.from(_messages)));
    } else if (_messages.isNotEmpty) {
      emit(ChatDetailDisconnected(messages: List.from(_messages)));
    }
  }

  /// Send a text message
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = MessageModel(
      chatId: chatId,
      senderId: doctorId,
      senderType: 'doctor',
      receiverId: patientId,
      receiverType: 'patient',
      message: text.trim(),
      messageType: 'text',
      createdAt: DateTime.now().toIso8601String(),
    );

    // Add to local list immediately for optimistic UI
    _messages.add(message);
    if (!isClosed) {
      emit(ChatDetailMessageSent(messages: List.from(_messages)));
    }

    // Send through WebSocket
    _webSocketService.sendMessage(message);
  }

  /// Retry connection
  Future<void> retryConnection() async {
    _messageSubscription?.cancel();
    _statusSubscription?.cancel();
    await _webSocketService.disconnect();
    await _connectWebSocket();
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _statusSubscription?.cancel();
    _webSocketService.dispose();
    return super.close();
  }
}
