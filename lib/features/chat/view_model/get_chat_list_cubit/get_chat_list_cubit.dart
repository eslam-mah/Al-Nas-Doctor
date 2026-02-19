import 'package:alnas_doctor/features/chat/data/models/chat_model.dart';
import 'package:alnas_doctor/features/chat/data/repos/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_chat_list_state.dart';

class GetChatListCubit extends Cubit<GetChatListState> {
  GetChatListCubit() : super(GetChatListInitial());
  final ChatRepo chatRepo = ChatRepo();

  Future<void> getChatList() async {
    if (isClosed) return;
    emit(GetChatListLoading());
    final result = await chatRepo.getChatList();
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(GetChatListFailure(errorMessage: failure.message ?? '')),
      (chatModel) => emit(GetChatListSuccess(chatModel: chatModel)),
    );
  }
}
