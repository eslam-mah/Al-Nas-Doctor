part of 'register_token_cubit.dart';

sealed class RegisterTokenState extends Equatable {
  const RegisterTokenState();

  @override
  List<Object> get props => [];
}

final class RegisterTokenInitial extends RegisterTokenState {}

final class RegisterTokenLoading extends RegisterTokenState {}

final class RegisterTokenSuccess extends RegisterTokenState {}

final class RegisterTokenFailure extends RegisterTokenState {
  final FailureModel failure;

  const RegisterTokenFailure({required this.failure});
}
