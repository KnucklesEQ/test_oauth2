import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:test_oauth2/blocs/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final String githubClientID = 'bec31448a99e41c191cb';
  final String githubClientSecret = '77628eebe4637ee098e25f643d94fba8ae788ab6';
  final List<String> githubScopes = ['repo', 'read:org'];

  final Uri authorizeURI =
  Uri.parse('https://github.com/login/oauth/authorize');
  final Uri tokenURI = Uri.parse('https://github.com/login/oauth/access_token');
  final String apiURLBase = 'https://api.github.com/';

  HttpServer? _redirectServer;
  oauth2.Client? _client;

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

      await _redirectServer?.close();
      // Bind to an ephemeral port on localhost
      _redirectServer = await HttpServer.bind('localhost', 8200);
      /*int index = 0;
      await for (var request in _redirectServer!) {
        request.response.write("Hello world $index");
        request.response.close();
        index ++;
      }
      print("llego");*/
      var authenticatedHttpClient = await _getOAuth2Client(
        //Uri.parse('http://localhost:${_redirectServer!.port}/auth'),
        Uri.parse('http://localhost:8200'),
      );

      _client = authenticatedHttpClient;
      print("Access Token: " + _client!.credentials.accessToken);
      print(_client!.credentials.toJson().toString());
      /*
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
          print(response.toString());
        }
      } on DioError catch (error) {
        debugPrint('CATCH ERROR en LOGIN USER: ' + error.toString());
      } finally {
        dio.close();
      }*/

      yield LoginStateIdle();
      return;
    }
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      githubClientID,
      authorizeURI,
      tokenURI,
      secret: githubClientSecret,
      httpClient: _JsonAcceptingHttpClient(),
    );
    var authorizationUrl =
    grant.getAuthorizationUrl(redirectUrl, scopes: githubScopes);

    await _redirect(authorizationUrl);
    var responseQueryParameters = await _listen();
    var client =
    await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }

  Future<void> _redirect(Uri authorizationUrl) async {
    var url = authorizationUrl.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<Map<String, String>> _listen() async {
    var request;// = await _redirectServer!.first;

    int index = 0;
    await for (var requested in _redirectServer!) {
      request = requested;
      requested.response.writeln("Hello world $index");
      //requested.response.close();
      index++;
      break;
    }

    var params = request.uri.queryParameters;
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await _redirectServer!.close();
    _redirectServer = null;
    return params;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}