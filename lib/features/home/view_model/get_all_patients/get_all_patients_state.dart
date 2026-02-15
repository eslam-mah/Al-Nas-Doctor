part of 'get_all_patients_cubit.dart';

sealed class GetAllPatientsState extends Equatable {
  const GetAllPatientsState();

  @override
  List<Object> get props => [];
}

final class GetAllPatientsInitial extends GetAllPatientsState {}

final class GetAllPatientsLoading extends GetAllPatientsState {}

final class GetAllPatientsSuccess extends GetAllPatientsState {
  final List<PatientData> patients;
  final int totalPatients;
  final bool hasMore;

  const GetAllPatientsSuccess({
    required this.patients,
    required this.totalPatients,
    required this.hasMore,
  });

  @override
  List<Object> get props => [patients, totalPatients, hasMore];
}

final class GetAllPatientsError extends GetAllPatientsState {
  final FailureModel errorMessage;
  const GetAllPatientsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
