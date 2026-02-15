import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/authentication/data/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());
  final AuthRepo authRepo = AuthRepo();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (isClosed) return;
    emit(ChangePasswordLoading());
    final result = await authRepo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(ChangePasswordFailure(failure)),
      (response) => emit(ChangePasswordSuccess()),
    );
  }
}
