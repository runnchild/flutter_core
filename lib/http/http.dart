import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import 'log_intercept.dart';

class Http {
  static Http? _client;

  static late String baseUrl;

  factory Http() => _getInstance();

  static Http get instance => _getInstance();

  static Http _getInstance() {
    return _client ??= Http._internal();
  }

  static late String _sourceId;
  static late String _secret;

  static init({
    required String baseUrl,
    required String sourceId,
    required String secret,
  }) {
    Http.baseUrl = baseUrl;
    _sourceId = sourceId;
    _secret = secret;
  }

  late Dio dio;

  Http._internal() {
    var millsSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var sourceId = _sourceId;
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
    String auth = "$_secret$mills$sourceId";
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
