import 'package:dio/dio.dart';
import '../exceptions/api_exception.dart';
import '../logger/app_logger.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info('REQ: ${options.method} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info('RES: ${response.statusCode} ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('ERR: ${err.message}', err.stackTrace);
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      error: ApiException(err.message ?? 'Kesalahan Jaringan', kode: err.response?.statusCode),
    ));
  }
}
