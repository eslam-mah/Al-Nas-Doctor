import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/chat/data/repos/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'accept_request_state.dart';

class AcceptRequestCubit extends Cubit<AcceptRequestState> {
  AcceptRequestCubit() : super(AcceptRequestInitial());
  final ChatRepo chatRepo = ChatRepo();
  Future<void> acceptRequest({required int requestId}) async {
    emit(AcceptRequestLoading());
    final result = await chatRepo.acceptRequest(requestId: requestId);
    result.fold(
      (failure) => emit(AcceptRequestFailure(errorMessage: failure)),
      (requests) => emit(AcceptRequestSuccess()),
    );
  }
}
