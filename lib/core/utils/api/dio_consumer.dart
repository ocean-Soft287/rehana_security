import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../../network/local/flutter_secure_storage.dart';
import 'endpoint.dart';
import 'api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {'Accept-Language': 'ar'};

    dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: MemCacheStore(),
          policy: CachePolicy.request,
          maxStale: const Duration(minutes: 30),
          priority: CachePriority.high,
        ),
      ),
    );

 
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }


  Future<Map<String, String>> _buildHeaders({bool withAuth = true}) async {
    final token = await SecureStorageService.read(SecureStorageService.token);

    return {
      'Accept-Language': 'ar',
      if (withAuth && token != null) 'Authorization': 'Bearer $token',
    };
  }

  

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(withAuth: true),
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future post(
    String path, {
    Object? data,
    bool isFromData = false,
    Map<String, dynamic>? queryParameters,
    bool withAuth = true,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(withAuth: withAuth),
          contentType: isFromData ? 'multipart/form-data' : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future put(
    String path, {
    Object? data,
    bool isFromData = false,
    Map<String, dynamic>? queryParameters,
    bool withAuth = true,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(withAuth: withAuth),
          contentType: isFromData ? 'multipart/form-data' : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future patch(
    String path, {
    Object? data,
    bool isFromData = false,
    Map<String, dynamic>? queryParameters,
    bool withAuth = true,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(withAuth: withAuth),
          contentType: isFromData ? 'multipart/form-data' : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future delete(
    String path, {
    Object? data,
    bool isFromData = false,
    Map<String, dynamic>? queryParameters,
    bool withAuth = true,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(withAuth: withAuth),
          contentType: 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }



  Future<Uint8List> downloadFile(
    String url, {
    String? savePath,
    bool withAuth = true,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.get<Uint8List>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: await _buildHeaders(withAuth: withAuth),
        ),
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 && response.data != null) {
        if (savePath != null) {
          await File(savePath).writeAsBytes(response.data!);
        }
        return response.data!;
      } else {
        throw Exception('Failed to download file');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }



  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      String message;

      if (data is String) {
        message = data;
      } else if (data is Map<String, dynamic>) {
        message =
            data['message']?.toString() ??
            data['error']?.toString() ??
            'حدث خطأ ما';
      } else {
        message = 'Server error ($statusCode)';
      }

      return Exception(message);
    } else {
      return Exception('Network error: ${e.message}');
    }
  }
}