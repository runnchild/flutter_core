import 'dart:convert';

import 'package:dio/dio.dart';

import '../shared/logger_extension.dart';

class LogIntercept extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert((){
      kPrint("\n┌────────────────────Start Http Request────────────────────", usePrint: true);
      kPrint("Request_BaseUrl:${options.baseUrl}${options.path}", usePrint: true);
      kPrint("Request_Method:${options.method}", usePrint: true);
      kPrint("Request_Headers:${options.headers}", usePrint: true);
      kPrint("Request_Data:${options.data}", usePrint: true);
      kPrint("Request_QueryParameters:${options.queryParameters}", usePrint: true);
      kPrint("└────────────────────End Http Request────────────────────", usePrint: true);
      return true;
    }());

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    assert((){
      kPrint("┌────────────────────Start Http Response────────────────────", usePrint: true);
      kPrint("│ Response_BaseUrl:${response.requestOptions.baseUrl}${response.requestOptions.path}", usePrint: true);
      kPrint("│ Response_StatusCode:${response.statusCode}", usePrint: true);
      kPrint("│ Response_StatusMessage:${response.statusMessage}", usePrint: true);
      var data = response.data;
      logger.d(data is String ? jsonDecode(data) : data);
      kPrint("└────────────────────End Http Response────────────────────", usePrint: true);
      return true;
    }());
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    logger.e(err);
  }
}