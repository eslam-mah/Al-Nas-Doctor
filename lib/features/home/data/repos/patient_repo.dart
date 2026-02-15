import 'package:alnas_doctor/core/config/api_endpoints.dart';
import 'package:alnas_doctor/core/services/http_service/dio_helper.dart';
import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/home/data/models/patient_model.dart';
import 'package:dartz/dartz.dart';

class PatientRepo {
  Future<Either<FailureModel, PatientModel>> getAllPatients({
    required String specialty,
    required int page,
  }) async {
    final result = await DioHelper.getData(
      endpoint:
          "${ApiEndpoints.getPatients}&specialty=$specialty&page=$page&limit=10",
      requiresAuth: true,
    );
    return result.fold((failure) => Left(failure), (response) {
      return Right(PatientModel.fromJson(response));
    });
  }

  Future<Either<FailureModel, PatientModel>> searchPatients({
    required String search,
    required String specialty,
    required int page,
  }) async {
    final result = await DioHelper.getData(
      endpoint:
          "${ApiEndpoints.getPatients}&search=$search&specialty=$specialty&page=$page&limit=10",
      requiresAuth: true,
    );
    return result.fold((failure) => Left(failure), (response) {
      return Right(PatientModel.fromJson(response));
    });
  }
}
