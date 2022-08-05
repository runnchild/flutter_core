import 'package:dio/dio.dart';

import '../shared/logger_extension.dart';

class LogIntercept extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert((){
      kPrint("\n┌────────────────────Start Http Request────────────────────");
      kPrint("Request_BaseUrl:${options.baseUrl}${options.path}");
      kPrint("Request_Method:${options.method}");
      kPrint("Request_Headers:${options.headers}");
      kPrint("Request_Data:${options.data}");
      kPrint("Request_QueryParameters:${options.queryParameters}");
      kPrint("└────────────────────End Http Request────────────────────");
      return true;
    }());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    assert((){
      kPrint("┌────────────────────Start Http Response────────────────────");
      kPrint("│ Response_BaseUrl:${response.requestOptions.baseUrl}${response.requestOptions.path}");
      kPrint("│ Response_StatusCode:${response.statusCode}");
      kPrint("│ Response_StatusMessage:${response.statusMessage}");
      // print("| Response_Headers:${response.headers.toString()}");
      logger.d(String.fromCharCodes(Runes(response.data)));
      kPrint("└────────────────────End Http Response────────────────────");
      return true;
    }());
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    logger.e(err);
  }
}