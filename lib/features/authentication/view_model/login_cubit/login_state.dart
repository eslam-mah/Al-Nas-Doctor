part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final UserModel userModel;
  const LoginSuccess({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

final class LoginFailure extends LoginState {
  final FailureModel failure;
  const LoginFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
