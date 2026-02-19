part of 'get_chat_list_cubit.dart';

sealed class GetChatListState extends Equatable {
  const GetChatListState();

  @override
  List<Object> get props => [];
}

final class GetChatListInitial extends GetChatListState {}

final class GetChatListLoading extends GetChatListState {}

final class GetChatListSuccess extends GetChatListState {
  final List<ChatData> chatModel;

  const GetChatListSuccess({required this.chatModel});
}

final class GetChatListFailure extends GetChatListState {
  final String errorMessage;

  const GetChatListFailure({required this.errorMessage});
}
