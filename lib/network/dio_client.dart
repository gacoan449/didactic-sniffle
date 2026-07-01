import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'api_client.dart';
import 'interceptor.dart';

class DioClient extends ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? AppConfig.apiUrl,
      connectTimeout: AppConfig.timeoutServer,
      receiveTimeout: AppConfig.timeoutServer,
    ),
  );

  DioClient() {
    _dio.interceptors.add(AppInterceptor());
    if (!AppConfig.modeDebug) return;
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }

  @override
  Future get(String url, {Map<String, dynamic>? param}) async {
    return await _dio.get(url, queryParameters: param);
  }

  @override
  Future post(String url, {dynamic data}) async {
    return await _dio.post(url, data: data);
  }

  @override
  Future put(String url, {dynamic data}) async {
    return await _dio.put(url, data: data);
  }

  @override
  Future delete(String url) async {
    return await _dio.delete(url);
  }
}
