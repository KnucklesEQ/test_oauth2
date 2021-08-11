import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:test_oauth2/session/active_session.dart';

class AppInterceptor extends Interceptor {
  ActiveSession _activeSession = new ActiveSession();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String token = await _activeSession.hasToken();

    debugPrint('################## Intercept HTTP Request ##################');
    options.headers[HttpHeaders.contentTypeHeader] = "application/json";
    options.headers[HttpHeaders.authorizationHeader] = token;

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return super.onError(err, handler);
  }
}
