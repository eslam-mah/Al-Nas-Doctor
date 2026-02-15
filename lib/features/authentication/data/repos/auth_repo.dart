import 'package:alnas_doctor/core/config/api_endpoints.dart';
import 'package:alnas_doctor/core/services/http_service/dio_helper.dart';
import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/authentication/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class AuthRepo {
  Future<Either<FailureModel, UserModel>> login({
    required String username,
    required String password,
  }) async {
    final result = await DioHelper.postData(
      endpoint: ApiEndpoints.doctorLogin,
      data: {"username": username, "password": password},
      isFormData: true,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(UserModel.fromJson(response)),
    );
  }

  Future<Either<FailureModel, Map<String, dynamic>>> logout() async {
    final result = await DioHelper.postData(
      endpoint: ApiEndpoints.doctorLogout,
      data: {},
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response),
    );
  }

  Future<Either<FailureModel, Map<String, dynamic>>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final result = await DioHelper.postData(
      endpoint: ApiEndpoints.doctorChangePassword,
      data: {"old_password": oldPassword, "new_password": newPassword},
      isFormData: false,
      requiresAuth: true,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response),
    );
  }
}
