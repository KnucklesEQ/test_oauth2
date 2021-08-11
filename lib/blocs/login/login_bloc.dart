import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:test_oauth2/blocs/login/login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final String githubClientID = 'bec31448a99e41c191cb';
  final String githubClientSecret = '77628eebe4637ee098e25f643d94fba8ae788ab6';

  final String authorizeURL = 'https://github.com/login/oauth/authorize';
  final String tokenURL = 'https://github.com/login/oauth/access_token';
  final String apiURLBase = 'https://api.github.com/';

  LoginBloc() : super(LoginStateUninitialized());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EventLoginInit) {
      yield LoginStateLoading();
      yield LoginStateIdle();
      return;
    }

    if (event is EventLoginButtonPress) {
      yield LoginStateLoading();

      Dio dio = new Dio();
      Map<String, dynamic>? map = {};
      map['response_type'] = 'code';
      map['client_id'] = githubClientID;
      map['redirect_uri'] = 'http://127.0.0.1:8200/#/patatasdeburgos';
      map['scope'] = ['user', 'public_repo'];
      map['state'] = 'chumbawamba';

      try {
        Response response = await dio.get(apiURLBase, queryParameters: map);

        debugPrint('Login -> Status Code: ' + response.statusCode.toString());

        if (response.statusCode == 200) {
          print("Entro");
        }
      } on DioError catch (error) {
        debugPrint('CATCH ERROR en LOGIN USER: ' + error.toString());
      } finally {
        dio.close();
      }

      yield LoginStateIdle();
      return;
    }
  }
}
