part of 'close_chat_cubit.dart';

sealed class CloseChatState extends Equatable {
  const CloseChatState();

  @override
  List<Object> get props => [];
}

final class CloseChatInitial extends CloseChatState {}

final class CloseChatLoading extends CloseChatState {}

final class CloseChatSuccess extends CloseChatState {}

final class CloseChatFailure extends CloseChatState {
  final FailureModel failure;

  const CloseChatFailure({required this.failure});
}
