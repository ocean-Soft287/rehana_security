import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../../network/local/flutter_secure_storage.dart';
import 'endpoint.dart';
import 'api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;

    dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: MemCacheStore(),
          policy: CachePolicy.request,
          maxStale: const Duration(minutes: 30),
          priority: CachePriority.high,
          keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        ),
      ),
    );

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await SecureStorageService.read(SecureStorageService.token);
    return {
      'Accept-Language': 'ar',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future get(String path, {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(),
          extra: {
            'cache': true,
            'maxStale': const Duration(minutes: 30),
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
      rethrow;
    }
  }

  @override
  Future post(String path,
      {Object? data,
        Map<String, dynamic>? queryParameters,
        bool isFromData = false}) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(),
          contentType:
          isFromData ? 'multipart/form-data' : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
      rethrow;
    }
  }

  @override
  Future patch(String path,
      {Object? data,
        Map<String, dynamic>? queryParameters,
        bool isFromData = false}) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(),
          contentType:
          isFromData ? 'multipart/form-data' : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
      rethrow;
    }
  }

  @override
  Future delete(String path,
      {Object? data,
        Map<String, dynamic>? queryParameters,
        bool isFromData = false}) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: await _buildHeaders(),
          contentType:
          isFromData ? 'multipart/form-data' : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      handleDioExceptions(e);
      rethrow;
    }
  }

  void handleDioExceptions(DioException e) {
    if (e.response != null) {
//      print('${e.response!.statusCode} - ${e.response!.data}');
    } else {
      // print('Dio error: ${e.message}');
    }
  }
}
