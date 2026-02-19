import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/notifications/data/repos/notifications_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_token_state.dart';

class RegisterTokenCubit extends Cubit<RegisterTokenState> {
  RegisterTokenCubit() : super(RegisterTokenInitial());
  final NotificationsRepo notificationsRepo = NotificationsRepo();
  Future<void> registerToken({
    required String fcmToken,
    required String deviceId,
    required int userId,
  }) async {
    emit(RegisterTokenLoading());
    final result = await notificationsRepo.registerFcmToken(
      fcmToken: fcmToken,
      deviceId: deviceId,
      userId: userId,
    );
    result.fold(
      (failure) => emit(RegisterTokenFailure(failure: failure)),
      (response) => emit(RegisterTokenSuccess()),
    );
  }
}
