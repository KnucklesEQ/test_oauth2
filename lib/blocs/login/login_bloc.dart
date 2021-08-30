import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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

  HttpServer? _redirectServer;
  oauth2.Client? _client;

  LoginBloc() : super(LoginStateUninitialized());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EventLoginInit) {
      if(event.gitHubCode.isNotEmpty){
        var grant = oauth2.AuthorizationCodeGrant(
          githubClientID,
          authorizeURI,
          tokenURI,
          secret: githubClientSecret,
          httpClient: _JsonAcceptingHttpClient(),
        );

        Map<String, String> responseQueryParameters = {};
        responseQueryParameters["code"] = event.gitHubCode;

        _client = await grant.handleAuthorizationResponse(responseQueryParameters);

        debugPrint("Access Token: " + _client!.credentials.accessToken);
        print(_client!.credentials.toJson().toString());

        yield LoginStateGitHubRefreshData(
          accessToken: _client!.credentials.accessToken,
          authToken: responseQueryParameters.toString(),
        );
      }

      yield LoginStateIdle();
      return;
    }

    if (event is EventLoginGitHubButtonPress) {
      yield LoginStateStartLoadingGitHub();

      var grant = oauth2.AuthorizationCodeGrant(
        githubClientID,
        authorizeURI,
        tokenURI,
        secret: githubClientSecret,
        httpClient: _JsonAcceptingHttpClient(),
      );

      Uri authorizationUrl = grant.getAuthorizationUrl(
        Uri.parse('http://localhost:8200/callbackgh.html'),
        scopes: githubScopes,
      );

      if (kIsWeb) {
        await _redirect(authorizationUrl);

        return;
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        await _redirectServer?.close();
        // Bind to an ephemeral port on localhost
        _redirectServer = await HttpServer.bind('localhost', 8200);

        await _redirect(authorizationUrl);
        Map<String, String> responseQueryParameters = await _listen();
        debugPrint(
            "Response Parameters: " + responseQueryParameters.toString());
        _client =
            await grant.handleAuthorizationResponse(responseQueryParameters);

        debugPrint("Access Token: " + _client!.credentials.accessToken);
        print(_client!.credentials.toJson().toString());

        yield LoginStateGitHubRefreshData(
          accessToken: _client!.credentials.accessToken,
          authToken: responseQueryParameters.toString(),
        );
      }
      yield LoginStateEndLoadingGitHub();
      yield LoginStateIdle();
      return;
    }

    if (event is EventLoginOffice365ButtonPress) {
      yield LoginStateStartLoadingOffice365();

      yield LoginStateEndLoadingOffice365();
      yield LoginStateIdle();
      return;
    }
  }

  Future<void> _redirect(Uri authorizationUrl) async {
    var url = authorizationUrl.toString();
    if (await canLaunch(url)) {
      if (kIsWeb) {
        await launch(url, webOnlyWindowName: '_self');
      }
      else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows)
        await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<Map<String, String>> _listen() async {
    var request = await _redirectServer!.first;
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
