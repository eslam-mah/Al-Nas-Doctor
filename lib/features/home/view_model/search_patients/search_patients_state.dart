part of 'search_patients_cubit.dart';

sealed class SearchPatientsState extends Equatable {
  const SearchPatientsState();

  @override
  List<Object> get props => [];
}

final class SearchPatientsInitial extends SearchPatientsState {}

final class SearchPatientsLoading extends SearchPatientsState {}

final class SearchPatientsSuccess extends SearchPatientsState {
  final List<PatientData> patients;
  final int totalPatients;
  final bool hasMore;

  const SearchPatientsSuccess({
    required this.patients,
    required this.totalPatients,
    required this.hasMore,
  });

  @override
  List<Object> get props => [patients, totalPatients, hasMore];
}

final class SearchPatientsError extends SearchPatientsState {
  final FailureModel errorMessage;
  const SearchPatientsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
