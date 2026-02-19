part of 'accept_request_cubit.dart';

sealed class AcceptRequestState extends Equatable {
  const AcceptRequestState();

  @override
  List<Object> get props => [];
}

final class AcceptRequestInitial extends AcceptRequestState {}

final class AcceptRequestLoading extends AcceptRequestState {}

final class AcceptRequestSuccess extends AcceptRequestState {}

final class AcceptRequestFailure extends AcceptRequestState {
  final FailureModel errorMessage;
  const AcceptRequestFailure({required this.errorMessage});
}
