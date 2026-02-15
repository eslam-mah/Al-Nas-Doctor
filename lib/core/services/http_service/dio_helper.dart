import 'dart:io';

import 'package:alnas_doctor/core/services/http_service/failure_model.dart';
import 'package:alnas_doctor/core/services/http_service/http_response_status.dart';
import 'package:alnas_doctor/core/utils/pref_keys.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static Dio? _dio;
  static bool _initialized = false;

  /// Base URL for the API - configure this for your backend
  static const String _baseUrl = 'https://41.33.8.201:4430/alnas_app';

  /// Initialize Dio instance
  /// Call this once in main.dart: await DioHelper.init();
  static Future<void> init() async {
    if (_initialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    // ⚠️ DEVELOPMENT ONLY: Bypass SSL certificate verification
    // Remove this in production or use proper SSL certificates
    (_dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // Add interceptors for logging
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (kDebugMode) {
            debugPrint('═══════════════════════════════════════════════════');
            debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
            debugPrint('Headers: ${options.headers}');
            if (options.data != null) {
              debugPrint('Data: ${options.data}');
            }
            debugPrint('═══════════════════════════════════════════════════');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('═══════════════════════════════════════════════════');
            debugPrint(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
            debugPrint('Response Datadddddddddddddddddd: ${response.data}');
            debugPrint('═══════════════════════════════════════════════════');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            debugPrint('═══════════════════════════════════════════════════');
            debugPrint('ERROR OCCURRED');
            debugPrint('═══════════════════════════════════════════════════');
            debugPrint('Path: ${e.requestOptions.path}');
            debugPrint('Full URL: ${e.requestOptions.uri}');
            debugPrint('Method: ${e.requestOptions.method}');
            debugPrint('Status Code: ${e.response?.statusCode}');
            debugPrint('Error Type: ${e.type}');
            debugPrint('Error Message: ${e.message}');

            if (e.response != null) {
              debugPrint('Response Data: ${e.response?.data}');
            }

            _logErrorType(e.type);
            debugPrint('═══════════════════════════════════════════════════');
          }
          return handler.next(e);
        },
      ),
    );

    _initialized = true;
    if (kDebugMode) {
      debugPrint('DioHelper initialized successfully');
    }
  }

  static void _logErrorType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        debugPrint('⚠️ Connection timeout - Server took too long to respond');
        break;
      case DioExceptionType.receiveTimeout:
        debugPrint('⚠️ Receive timeout - Server response took too long');
        break;
      case DioExceptionType.badCertificate:
        debugPrint('⚠️ SSL Certificate error');
        break;
      case DioExceptionType.connectionError:
        debugPrint('⚠️ Connection error - Check network/server availability');
        break;
      case DioExceptionType.unknown:
        debugPrint('⚠️ Unknown error');
        break;
      default:
        break;
    }
  }

  /// Get Dio instance
  static Dio _getDio() {
    if (!_initialized || _dio == null) {
      throw Exception(
        'DioHelper not initialized. Call DioHelper.init() in main.dart',
      );
    }
    return _dio!;
  }

  // ============================================
  // TOKEN MANAGEMENT
  // ============================================

  /// Save JWT token
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.kToken, token);
    if (kDebugMode) {
      debugPrint('DioHelper: Token saved successfully');
    }
  }

  /// Get JWT token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PrefKeys.kToken);
  }

  /// Clear JWT token (logout)
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefKeys.kToken);
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Build request options with optional JWT
  static Future<Options> _buildOptions({
    bool requiresAuth = false,
    Map<String, dynamic>? extraHeaders,
    String? contentType,
  }) async {
    final headers = <String, dynamic>{};

    if (requiresAuth) {
      final token = await getToken();
      print('=================================');
      print('Token being: $token');
      print('=================================');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return Options(
      headers: headers.isNotEmpty ? headers : null,
      contentType: contentType,
    );
  }

  // ============================================
  // HTTP METHODS
  // ============================================

  /// GET request
  static Future<Either<FailureModel, Map<String, dynamic>>> getData({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = false,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() async {
      final options = await _buildOptions(
        requiresAuth: requiresAuth,
        extraHeaders: headers,
        contentType: Headers.jsonContentType,
      );
      return _getDio().get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    });
  }

  /// POST request
  static Future<Either<FailureModel, Map<String, dynamic>>> postData({
    required String endpoint,
    required Map<String, dynamic> data,
    bool requiresAuth = false,
    bool isFormData = false,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() async {
      final options = await _buildOptions(
        requiresAuth: requiresAuth,
        extraHeaders: headers,
        contentType: isFormData ? null : Headers.jsonContentType,
      );
      final dynamic finalData = isFormData ? FormData.fromMap(data) : data;
      return _getDio().post(endpoint, data: finalData, options: options);
    });
  }

  /// PUT request
  static Future<Either<FailureModel, Map<String, dynamic>>> putData({
    required String endpoint,
    required Map<String, dynamic> data,
    bool requiresAuth = false,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() async {
      final options = await _buildOptions(
        requiresAuth: requiresAuth,
        extraHeaders: headers,
        contentType: Headers.jsonContentType,
      );
      return _getDio().put(endpoint, data: data, options: options);
    });
  }

  /// PATCH request
  static Future<Either<FailureModel, Map<String, dynamic>>> patchData({
    required String endpoint,
    required Map<String, dynamic> data,
    bool requiresAuth = false,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() async {
      final options = await _buildOptions(
        requiresAuth: requiresAuth,
        extraHeaders: headers,
        contentType: Headers.jsonContentType,
      );
      return _getDio().patch(endpoint, data: data, options: options);
    });
  }

  /// DELETE request
  static Future<Either<FailureModel, Map<String, dynamic>>> deleteData({
    required String endpoint,
    Map<String, dynamic>? data,
    bool requiresAuth = false,
    Map<String, dynamic>? headers,
  }) async {
    return _handleRequest(() async {
      final options = await _buildOptions(
        requiresAuth: requiresAuth,
        extraHeaders: headers,
        contentType: Headers.jsonContentType,
      );
      return _getDio().delete(endpoint, data: data, options: options);
    });
  }

  // ============================================
  // FILE UPLOAD METHODS
  // ============================================

  /// Upload single file with POST
  static Future<Either<FailureModel, Map<String, dynamic>>> postFile({
    required String endpoint,
    required File file,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    bool requiresAuth = false,
  }) async {
    if (!await file.exists()) {
      return Left(
        FailureModel(
          responseStatus: HttpResponseStatus.failure,
          message: "File not found at path: ${file.path}",
        ),
      );
    }

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final mimeTypeData = mimeType.split('/');

    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ),
      ...?additionalData,
    });

    return _handleRequest(() async {
      final options = await _buildOptions(requiresAuth: requiresAuth);
      return _getDio().post(endpoint, data: formData, options: options);
    });
  }

  /// Upload multiple files with POST
  static Future<Either<FailureModel, Map<String, dynamic>>> postMultipleFiles({
    required String endpoint,
    required List<File> files,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    bool requiresAuth = false,
  }) async {
    final Map<String, dynamic> formDataMap = {};

    if (additionalData != null) {
      formDataMap.addAll(additionalData);
    }

    for (int i = 0; i < files.length; i++) {
      final file = files[i];

      if (!await file.exists()) {
        return Left(
          FailureModel(
            responseStatus: HttpResponseStatus.failure,
            message: "File not found at path: ${file.path}",
          ),
        );
      }

      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final mimeTypeData = mimeType.split('/');

      formDataMap['$fieldName[$i]'] = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      );
    }

    final formData = FormData.fromMap(formDataMap);

    return _handleRequest(() async {
      final options = await _buildOptions(requiresAuth: requiresAuth);
      return _getDio().post(endpoint, data: formData, options: options);
    });
  }

  // ============================================
  // SPECIAL METHODS
  // ============================================

  /// Login - saves token automatically on success
  static Future<Either<FailureModel, Map<String, dynamic>>> login({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    return _handleRequest(
      () => _getDio().post(endpoint, data: data),
      onSuccess: (response) async {
        // Try to extract token from common response structures
        String? token;

        if (response.data is Map) {
          final responseData = response.data as Map;

          // Check common token locations
          if (responseData['data'] != null &&
              responseData['data']['token'] != null) {
            token = responseData['data']['token'];
          } else if (responseData['token'] != null) {
            token = responseData['token'];
          } else if (responseData['access_token'] != null) {
            token = responseData['access_token'];
          }
        }

        if (token != null) {
          await saveToken(token);
        }
      },
    );
  }

  /// Logout - clears token
  static Future<Either<FailureModel, Map<String, dynamic>>> logout({
    String? endpoint,
  }) async {
    if (endpoint != null) {
      // Call logout endpoint if provided
      final result = await postData(
        endpoint: endpoint,
        data: {},
        requiresAuth: true,
      );
      await clearToken();
      return result;
    } else {
      // Just clear the token locally
      await clearToken();
      return Right({'message': 'Logged out successfully'});
    }
  }

  // ============================================
  // REQUEST HANDLER
  // ============================================

  static Future<Either<FailureModel, Map<String, dynamic>>> _handleRequest(
    Future<Response> Function() requestFunction, {
    Future<void> Function(Response response)? onSuccess,
  }) async {
    try {
      final response = await requestFunction();

      if (kDebugMode) {
        debugPrint('Status Code: ${response.statusCode}');
      }

      // Success status codes
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 204) {
        if (onSuccess != null) {
          await onSuccess(response);
        }

        // Handle various response types
        if (response.data == null || response.data == '') {
          return Right({'message': 'Success'});
        } else if (response.data is Map) {
          final responseData = Map<String, dynamic>.from(response.data);

          // Check for backend logical error (status: false)
          if (responseData['status'] == false) {
            return Left(
              FailureModel(
                responseStatus: HttpResponseStatus.failure,
                message: responseData['message'] ?? 'Request failed',
              ),
            );
          }

          return Right(responseData);
        } else if (response.data is List) {
          return Right({'data': response.data});
        } else {
          return Right({'data': response.data});
        }
      }

      // Error status codes
      return Left(_buildFailure(response.statusCode, response.data));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Exception occurred: $e');
      }
      return Left(
        FailureModel(
          responseStatus: HttpResponseStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  static FailureModel _buildFailure(int? statusCode, dynamic data) {
    String message = 'Request failed';

    if (data is Map) {
      message = data['message'] ?? data['error'] ?? 'Request failed';
    }

    switch (statusCode) {
      case 400:
        return FailureModel(
          responseStatus: HttpResponseStatus.invalidData,
          message: message,
        );
      case 401:
        return FailureModel(
          responseStatus: HttpResponseStatus.unauthorized,
          message: message,
        );
      case 403:
        return FailureModel(
          responseStatus: HttpResponseStatus.forbidden,
          message: message,
        );
      case 404:
        return FailureModel(
          responseStatus: HttpResponseStatus.notFound,
          message: message,
        );
      case 422:
        return FailureModel(
          responseStatus: HttpResponseStatus.validationError,
          message: message,
        );
      case 500:
        return FailureModel(
          responseStatus: HttpResponseStatus.serverError,
          message: message,
        );
      default:
        return FailureModel(
          responseStatus: HttpResponseStatus.failure,
          message: message,
        );
    }
  }

  static FailureModel _handleDioException(DioException e) {
    if (kDebugMode) {
      debugPrint('DioException: ${e.message}');
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return FailureModel(
        responseStatus: HttpResponseStatus.timeout,
        message: 'Connection timeout. Please try again.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return FailureModel(
        responseStatus: HttpResponseStatus.noInternet,
        message: 'No internet connection. Please check your network.',
      );
    }

    if (e.response != null) {
      return _buildFailure(e.response?.statusCode, e.response?.data);
    }

    return FailureModel(
      responseStatus: HttpResponseStatus.failure,
      message: e.message ?? 'Unknown error occurred',
    );
  }
}
