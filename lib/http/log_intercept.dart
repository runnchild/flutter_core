import 'package:dio/dio.dart';

import '../shared/logger_extension.dart';

class LogIntercept extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert((){
      print("\n┌────────────────────Start Http Request────────────────────");
      print("Request_BaseUrl:${options.baseUrl}${options.path}");
      print("Request_Method:${options.method}");
      print("Request_Headers:${options.headers}");
      print("Request_Data:${options.data}");
      print("Request_QueryParameters:${options.queryParameters}");
      print("└────────────────────End Http Request────────────────────");
      return true;
    }());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    assert((){
      print("┌────────────────────Start Http Response────────────────────");
      print("│ Response_BaseUrl:${response.requestOptions.baseUrl}${response.requestOptions.path}");
      print("│ Response_StatusCode:${response.statusCode}");
      print("│ Response_StatusMessage:${response.statusMessage}");
      // print("| Response_Headers:${response.headers.toString()}");
      logger.d(String.fromCharCodes(Runes(response.data)));
      print("└────────────────────End Http Response────────────────────");
      return true;
    }());
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    logger.e(err);
  }
}