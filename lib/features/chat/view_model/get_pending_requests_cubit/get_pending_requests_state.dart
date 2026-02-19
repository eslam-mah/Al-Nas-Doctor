part of 'get_pending_requests_cubit.dart';

sealed class GetPendingRequestsState extends Equatable {
  const GetPendingRequestsState();

  @override
  List<Object> get props => [];
}

final class GetPendingRequestsInitial extends GetPendingRequestsState {}

final class GetPendingRequestsLoading extends GetPendingRequestsState {}

final class GetPendingRequestsSuccess extends GetPendingRequestsState {
  final RequestModel requests;
  const GetPendingRequestsSuccess({required this.requests});

  @override
  List<Object> get props => [requests];
}

final class GetPendingRequestsFailure extends GetPendingRequestsState {
  final String errorMessage;
  const GetPendingRequestsFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
