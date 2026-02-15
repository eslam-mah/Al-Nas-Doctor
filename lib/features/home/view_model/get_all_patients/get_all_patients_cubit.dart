import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/features/home/data/models/patient_model.dart';
import 'package:alnas_doctor/features/home/data/repos/patient_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_all_patients_state.dart';

class GetAllPatientsCubit extends Cubit<GetAllPatientsState> {
  GetAllPatientsCubit() : super(GetAllPatientsInitial());

  final PatientRepo _patientRepo = PatientRepo();
  final specialty = UserSession.instance.currentUser?.userData?.specialty ?? '';

  // Accumulated data for infinite scroll
  final List<PatientData> _allPatients = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalPatients = 0;
  bool _isLoading = false;

  bool get hasMore => _currentPage < _totalPages;
  int get totalPatients => _totalPatients;

  Future<void> getAllPatients() async {
    if (_isLoading) return;
    if (_currentPage > 0 && !hasMore) return;

    _isLoading = true;
    final nextPage = _currentPage + 1;

    if (nextPage == 1) emit(GetAllPatientsLoading());

    final result = await _patientRepo.getAllPatients(
      specialty: specialty,
      page: nextPage,
    );

    _isLoading = false;

    result.fold(
      (failure) {
        emit(GetAllPatientsError(errorMessage: failure));
      },
      (patientModel) {
        _currentPage = patientModel.pagination?.page ?? nextPage;
        _totalPages = patientModel.pagination?.pages ?? 0;
        _totalPatients = patientModel.pagination?.total ?? 0;
        _allPatients.addAll(patientModel.data ?? []);

        emit(
          GetAllPatientsSuccess(
            patients: List.unmodifiable(_allPatients),
            totalPatients: _totalPatients,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  /// Reset and fetch from page 1
  void refresh() {
    _allPatients.clear();
    _currentPage = 0;
    _totalPages = 0;
    _totalPatients = 0;
    _isLoading = false;
    getAllPatients();
  }
}
