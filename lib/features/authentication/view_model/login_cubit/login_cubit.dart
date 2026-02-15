import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/features/authentication/data/models/user_model.dart';
import 'package:alnas_doctor/features/authentication/data/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo = AuthRepo();

  LoginCubit() : super(LoginInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (isClosed) return;
    emit(LoginLoading());

    final result = await authRepo.login(username: username, password: password);

    if (isClosed) return;
    await result.fold((failure) async => emit(LoginFailure(failure: failure)), (
      userModel,
    ) async {
      // Save session globally
      await UserSession.instance.saveSession(userModel);
      emit(LoginSuccess(userModel: userModel));
    });
  }
}
