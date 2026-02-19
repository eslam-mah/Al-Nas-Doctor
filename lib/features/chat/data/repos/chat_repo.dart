import 'dart:convert';

import 'package:alnas_doctor/core/config/api_endpoints.dart';
import 'package:alnas_doctor/core/services/http_service/dio_helper.dart';
import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/features/chat/data/models/chat_model.dart';
import 'package:alnas_doctor/features/chat/data/models/message_model.dart';
import 'package:alnas_doctor/features/chat/data/models/request_model.dart';
import 'package:dartz/dartz.dart';

class ChatRepo {
  /// Helper to extract the actual parsed Map from DioHelper response.
  /// DioHelper may wrap non-Map responses as {'data': rawString},
  /// so we need to decode that string if necessary.
  Map<String, dynamic> _extractResponseMap(Map<String, dynamic> response) {
    // If response already has the expected keys, use it directly
    if (response.containsKey('requests') || response.containsKey('error')) {
      return response;
    }
    // Otherwise DioHelper wrapped it in {'data': ...}
    final inner = response['data'];
    if (inner is String) {
      return jsonDecode(inner) as Map<String, dynamic>;
    } else if (inner is Map) {
      return Map<String, dynamic>.from(inner);
    }
    return response;
  }

  Future<Either<FailureModel, RequestModel>> getChatRequestsPending() async {
    final result = await DioHelper.getData(
      endpoint: ApiEndpoints.chatRequestsPending,
      requiresAuth: true,
    );
    return result.fold((failure) => Left(failure), (response) {
      final data = _extractResponseMap(response);
      return Right(RequestModel.fromJson(data));
    });
  }

  Future<Either<FailureModel, Map<String, dynamic>>> acceptRequest({
    required int requestId,
  }) async {
    final result = await DioHelper.postData(
      endpoint: ApiEndpoints.chatRequestAccept,
      data: {'request_id': requestId},
      requiresAuth: true,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response),
    );
  }

  Future<Either<FailureModel, List<ChatData>>> getChatList() async {
    final result = await DioHelper.getData(
      endpoint: ApiEndpoints.chatList,
      requiresAuth: true,
    );

    return result.fold((failure) => Left(failure), (response) {
      final data = _extractResponseMap(response);
      final List list = data['data'] ?? data['chats'] ?? [];
      return Right(list.map((e) => ChatData.fromJson(e)).toList());
    });
  }

  Future<Either<FailureModel, Map<String, dynamic>>> closeChat({
    required int chatId,
  }) async {
    final result = await DioHelper.postData(
      endpoint: ApiEndpoints.chatClose,
      data: {'chat_id': chatId},
      requiresAuth: true,
    );

    return result.fold((failure) => Left(failure), (response) {
      final data = _extractResponseMap(response);
      return Right(data);
    });
  }

  /// Get chat messages history for a specific chat
  Future<Either<FailureModel, List<MessageModel>>> getChatMessages({
    required int chatId,
  }) async {
    final result = await DioHelper.getData(
      endpoint: ApiEndpoints.chatMessages,
      queryParameters: {'chat_id': chatId},
      requiresAuth: true,
    );

    return result.fold((failure) => Left(failure), (response) {
      final data = _extractResponseMap(response);
      final List list = data['data'] ?? data['messages'] ?? [];
      return Right(list.map((e) => MessageModel.fromJson(e)).toList());
    });
  }
}
