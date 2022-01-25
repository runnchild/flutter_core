import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'log_intercept.dart';

class Http {
  static Http? _client;

  static String get baseUrl => kDebugMode ? "http://api.story.dev.chenglie.tech/":"http://api-story.chenglie.tech/";

  factory Http() => _getInstance();

  static Http get instance => _getInstance();

  static Http _getInstance() {
    return _client ??= Http._internal();
  }

  late Dio dio;

  Http._internal() {
    var millsSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var sourceId = "1634036";
    var platform = "unknown";
    try {
      platform = Platform.isAndroid ? "Android" : "iOS";
    } catch (e) {
      //
    }

    dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 1000 * 60 * 60 * 24,
        responseType: ResponseType.json,
        headers: {
          "Content-Type": "application/json",
          "platform": platform,
          "ApiSourceId": sourceId,
          "ApiAuthKey": encrypt(millsSeconds, sourceId),
          "ApiAuthTime": "$millsSeconds",
        }))
      ..interceptors.add(LogIntercept());

    // getApplicationDocumentsDirectory().then((value) {
    //   dio.interceptors.add(DioCacheInterceptor(
    //     options: CacheOptions(
    //       store: FileCacheStore(value.path),
    //       policy: CachePolicy.refreshForceCache,
    //       allowPostMethod: true,
    //       hitCacheOnErrorExcept: [],
    //     ),
    //   ));
    // });
  }

  String encrypt(int mills, String sourceId) {
    String auth = "i1FTkkUT6mq0pzHh$mills$sourceId";
    return md5.convert(utf8.encode(auth)).toString();
  }

  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return dio.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }
}
