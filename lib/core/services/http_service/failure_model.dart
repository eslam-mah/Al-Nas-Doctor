import 'package:alnas_doctor/core/services/http_service/http_response_status.dart';

class FailureModel {
  String? message;
  HttpResponseStatus responseStatus;
  FailureModel({required this.responseStatus, this.message});
}
