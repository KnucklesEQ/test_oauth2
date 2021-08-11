import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_oauth2/utils/app_interceptor.dart';

class RestClient {
  final String baseUrl;
  late final Dio dio;

  ///Constructor (con Naming y requiere obligatoriamente baseUrl)
  ///Creamos el Dio asociado, que podrán usar directamente toda clase que
  ///extienda de esta
  RestClient({required this.baseUrl}) {
    //El header lo gestionamos en ApiInterceptor
    dio = new Dio()..interceptors.add(AppInterceptor());
  }

  ///Login a la API. Ésta nos va a devolver un token, con el que trabajaremos en
  ///futuras llamadas a la API
  Future<String> login({
    required String username,
    required String password,
  }) async {
    final String _loginRoute = baseUrl + '/login';
    Map<String, dynamic> map = {
      'username': username,
      'password': password,
    };

    String logedToken = '';
    //Fijarse que aquí NO utilizamos el HTTP Interceptor
    Dio dio = new Dio();

    try {
      Response response = await dio.post(_loginRoute, data: map);
      debugPrint('Login -> Status Code: ' + response.statusCode.toString());

      if (response.statusCode == 200) {
        logedToken =
            response.headers.value(HttpHeaders.authorizationHeader) ?? '';
        print('LogedToken -> ' + logedToken);
      }
    } on DioError catch (error) {
      debugPrint('CATCH ERROR en LOGIN USER: ' + error.toString());
      rethrow;
    } finally {
      dio.close();
    }

    return logedToken;
  }

  void close() {
    dio.close();
    return;
  }
}
