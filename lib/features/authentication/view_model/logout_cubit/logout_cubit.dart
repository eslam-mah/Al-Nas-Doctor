import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/authentication/data/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());
  final AuthRepo authRepo = AuthRepo();
  Future<void> logout() async {
    if (isClosed) return;
    emit(LogoutLoading());
    final result = await authRepo.logout();
    if (isClosed) return;
    result.fold(
      (failure) => emit(LogoutFailure(failure)),
      (response) => emit(LogoutSuccess()),
    );
  }
}
