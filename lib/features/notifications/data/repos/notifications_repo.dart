import 'package:alnas_doctor/core/config/api_endpoints.dart';
import 'package:alnas_doctor/core/services/http_service/dio_helper.dart';
import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:dartz/dartz.dart';

class NotificationsRepo {
  Future<Either<FailureModel, Map<String, dynamic>>> registerFcmToken({
    required String fcmToken,
    required String deviceId,
    required int userId,
  }) async {
    final data = <String, dynamic>{
      "fcm_token": fcmToken,
      "device_id": deviceId,
      "user_id": userId,
    };

    final result = await DioHelper.postData(
      endpoint: ApiEndpoints.registerFcmToken,
      data: data,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response),
    );
  }
}
