import 'package:alnas_doctor/features/chat/data/models/request_model.dart';
import 'package:alnas_doctor/features/chat/data/repos/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_pending_requests_state.dart';

class GetPendingRequestsCubit extends Cubit<GetPendingRequestsState> {
  GetPendingRequestsCubit() : super(GetPendingRequestsInitial()) {
    debugPrint('🟢 GetPendingRequestsCubit CREATED');
  }

  final ChatRepo chatRepo = ChatRepo();

  Future<void> getPendingRequests() async {
    debugPrint('🔵 getPendingRequests() CALLED, isClosed=$isClosed');
    if (isClosed) return;
    emit(GetPendingRequestsLoading());
    debugPrint('🔵 Emitted Loading state');
    final result = await chatRepo.getChatRequestsPending();
    debugPrint('🔵 Got result from repo');
    if (isClosed) {
      debugPrint('🔴 Cubit is CLOSED after await, skipping emit');
      return;
    }
    result.fold(
      (failure) {
        debugPrint('🔴 FAILURE: ${failure.message}');
        emit(GetPendingRequestsFailure(errorMessage: failure.message ?? ''));
      },
      (requests) {
        debugPrint('🟢 SUCCESS: requests count = ${requests.requests?.length}');
        emit(GetPendingRequestsSuccess(requests: requests));
      },
    );
  }
}
