import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse {
  final int statusCode;
  final String body;
  final Map<String, dynamic>? headers;

  ApiResponse({
    required this.statusCode,
    required this.body,
    this.headers,
  });
}

class ApiService {
  final Dio _dio;
  final String _baseUrl;
  
  ApiService({String? baseUrl})
      : _baseUrl = baseUrl ?? 'https://api.mediamosaic.app/api',
        _dio = Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.followRedirects = true;
    
    // Add interceptor for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
    }
    
    // Add auth token interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle unauthorized access - clear token and redirect to login
          _handleUnauthorized();
        }
        return handler.next(e);
      },
    ));
  }

  void _handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    // Navigate to login screen is typically handled by the auth repository
  }

  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      
      return ApiResponse(
        statusCode: response.statusCode ?? 500,
        body: json.encode(response.data),
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        body: json.encode({'error': e.toString()}),
      );
    }
  }

  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      
      return ApiResponse(
        statusCode: response.statusCode ?? 500,
        body: json.encode(response.data),
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        body: json.encode({'error': e.toString()}),
      );
    }
  }

  Future<ApiResponse> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      
      return ApiResponse(
        statusCode: response.statusCode ?? 500,
        body: json.encode(response.data),
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        body: json.encode({'error': e.toString()}),
      );
    }
  }

  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParams,
      );
      
      return ApiResponse(
        statusCode: response.statusCode ?? 500,
        body: json.encode(response.data),
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        body: json.encode({'error': e.toString()}),
      );
    }
  }

  ApiResponse _handleDioError(DioException e) {
    if (e.response != null) {
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        body: json.encode(e.response?.data ?? {'error': e.message}),
        headers: e.response?.headers.map,
      );
    } else {
      return ApiResponse(
        statusCode: 500,
        body: json.encode({'error': e.message}),
      );
    }
  }
}