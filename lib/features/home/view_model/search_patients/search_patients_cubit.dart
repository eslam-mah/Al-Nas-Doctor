import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/features/home/data/models/patient_model.dart';
import 'package:alnas_doctor/features/home/data/repos/patient_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_patients_state.dart';

class SearchPatientsCubit extends Cubit<SearchPatientsState> {
  SearchPatientsCubit() : super(SearchPatientsInitial());

  final PatientRepo _patientRepo = PatientRepo();
  final specialty = UserSession.instance.currentUser?.userData?.specialty ?? '';

  // Accumulated data for infinite scroll
  final List<PatientData> _allPatients = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalPatients = 0;
  bool _isLoading = false;
  String _lastQuery = '';

  bool get hasMore => _currentPage < _totalPages;
  int get totalPatients => _totalPatients;

  Future<void> searchPatients({required String search}) async {
    if (_isLoading) return;

    // If query changed, reset
    if (search != _lastQuery) {
      _allPatients.clear();
      _currentPage = 0;
      _totalPages = 0;
      _totalPatients = 0;
      _lastQuery = search;
    }

    if (_currentPage > 0 && !hasMore) return;

    _isLoading = true;
    final nextPage = _currentPage + 1;

    if (nextPage == 1) emit(SearchPatientsLoading());

    final result = await _patientRepo.searchPatients(
      search: search,
      specialty: specialty,
      page: nextPage,
    );

    _isLoading = false;

    result.fold(
      (failure) {
        emit(SearchPatientsError(errorMessage: failure));
      },
      (patientModel) {
        _currentPage = patientModel.pagination?.page ?? nextPage;
        _totalPages = patientModel.pagination?.pages ?? 0;
        _totalPatients = patientModel.pagination?.total ?? 0;
        _allPatients.addAll(patientModel.data ?? []);

        emit(
          SearchPatientsSuccess(
            patients: List.unmodifiable(_allPatients),
            totalPatients: _totalPatients,
            hasMore: hasMore,
          ),
        );
      },
    );
  }

  /// Reset search state
  void reset() {
    _allPatients.clear();
    _currentPage = 0;
    _totalPages = 0;
    _totalPatients = 0;
    _isLoading = false;
    _lastQuery = '';
    emit(SearchPatientsInitial());
  }
}
