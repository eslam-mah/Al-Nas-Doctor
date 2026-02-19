part of 'chat_detail_cubit.dart';

sealed class ChatDetailState extends Equatable {
  const ChatDetailState();

  @override
  List<Object> get props => [];
}

final class ChatDetailInitial extends ChatDetailState {}

final class ChatDetailLoading extends ChatDetailState {}

/// WebSocket connected and messages available
final class ChatDetailConnected extends ChatDetailState {
  final List<MessageModel> messages;

  const ChatDetailConnected({required this.messages});

  @override
  List<Object> get props => [messages, messages.length];
}

/// A new message was received
final class ChatDetailMessageReceived extends ChatDetailState {
  final List<MessageModel> messages;

  const ChatDetailMessageReceived({required this.messages});

  @override
  List<Object> get props => [messages, messages.length, DateTime.now()];
}

/// A message was sent (optimistic update)
final class ChatDetailMessageSent extends ChatDetailState {
  final List<MessageModel> messages;

  const ChatDetailMessageSent({required this.messages});

  @override
  List<Object> get props => [messages, messages.length, DateTime.now()];
}

/// WebSocket disconnected but messages are still available
final class ChatDetailDisconnected extends ChatDetailState {
  final List<MessageModel> messages;

  const ChatDetailDisconnected({required this.messages});

  @override
  List<Object> get props => [messages];
}

/// WebSocket reconnecting
final class ChatDetailReconnecting extends ChatDetailState {
  final List<MessageModel> messages;

  const ChatDetailReconnecting({required this.messages});

  @override
  List<Object> get props => [messages];
}

/// Connection error with messages still available
final class ChatDetailConnectionError extends ChatDetailState {
  final List<MessageModel> messages;
  final String error;

  const ChatDetailConnectionError({
    required this.messages,
    required this.error,
  });

  @override
  List<Object> get props => [messages, error];
}
