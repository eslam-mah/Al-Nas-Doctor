import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/chat/data/repos/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'close_chat_state.dart';

class CloseChatCubit extends Cubit<CloseChatState> {
  CloseChatCubit() : super(CloseChatInitial());
  final ChatRepo chatRepo = ChatRepo();
  Future<void> closeChat({required int chatId}) async {
    emit(CloseChatLoading());
    final result = await chatRepo.closeChat(chatId: chatId);
    result.fold(
      (failure) => emit(CloseChatFailure(failure: failure)),
      (data) => emit(CloseChatSuccess()),
    );
  }
}
