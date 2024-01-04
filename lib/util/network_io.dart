import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

// 使用dio库异步请求给定URL
Future<Response> request(String url, {String method = 'GET', Map<String, dynamic>? data}) async {
  var dio = Dio();
  var options = Options(
    method: method,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );
  var response = await dio.request(url, data: data, options: options);
  return response;
}

/// 用于构建Dio网络请求的工厂类
class DioFactory {

  final Options _options = Options();
  final Dio _dio = Dio();
  late final String _url;
  Map<String, dynamic>? _body;

  /// 设置请求URL
  DioFactory setRequestUrl(String url) {
    _url = url;
    return this;
  }

  /// 设置请求方法
  DioFactory setRequestMethod(RequestMethod method) {
    _options.method = method.method;
    return this;
  }

  /// 设置请求数据类型
  DioFactory setContentType(ContentType contentType) {
    _options.headers ??= {};
    _options.headers?[HttpHeaders.contentTypeHeader] = contentType.contentType;
    return this;
  }

  /// 设置请求头
  DioFactory setHeaders(Map<String, dynamic> headers) {
    _options.headers ??= {};
    _options.headers?.addAll(headers);
    return this;
  }

  /// 设置请求数据
  DioFactory setRequestBody(Map<String, dynamic> data) {
    _body = data;
    return this;
  }

  /// 设置请求回调，支持onResponse和onError
  DioFactory setCallback(
      void Function(Response, ResponseInterceptorHandler) onResponseCallback,
      void Function(DioException, ErrorInterceptorHandler) onErrorCallback
      ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        onResponseCallback(response, handler);
        return handler.next(response);
      },
      onError: (error, handler) {
        onErrorCallback(error, handler);
        return handler.next(error);
      },
    ));
    return this;
  }

  Future<void> request() async {
    _options.receiveDataWhenStatusError = true;
    await _dio.request(_url, data: _body, options: _options);
  }

}

enum RequestMethod {

  GET('GET'),
  POST('POST'),
  PUT('PUT'),
  DELETE('DELETE'),
  PATCH('PATCH'),
  HEAD('HEAD'),
  OPTIONS('OPTIONS');

  final String method;

  const RequestMethod(this.method);
}

enum ContentType {

  JSON('application/json'),
  FORM('application/x-www-form-urlencoded'),
  MULTIPART('multipart/form-data');

  final String contentType;

  const ContentType(this.contentType);
}