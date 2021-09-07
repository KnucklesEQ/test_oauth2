import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:test_oauth2/blocs/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:test_oauth2/session/active_session.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import 'package:test_oauth2/myoauth2lib/myoauth2lib.dart' as oauth2;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late ActiveSession _activeSession;

  final String githubClientID = 'bec31448a99e41c191cb';
  final String githubClientSecret = '77628eebe4637ee098e25f643d94fba8ae788ab6';
  final List<String> githubScopes = ['repo', 'read:org'];

  final Uri authorizeURI =
      Uri.parse('https://github.com/login/oauth/authorize');
  final Uri tokenURI = Uri.parse('https://github.com/login/oauth/access_token');

  HttpServer? _redirectServer;
  oauth2.Client? _client;

  html.WindowBase? _popupWin;
  oauth2.AuthorizationCodeGrant? grant2;

  LoginBloc() : super(LoginStateUninitialized()) {
    _activeSession = new ActiveSession();

    html.window.onMessage.listen((event) {
      print("Akuna Matata");
      print(event.data.toString());

      /// If the event contains the token it means the user is authenticated.
      if (event.data.toString().contains('code=')) {
        _login(event.data);
      }
    });
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EventLoginInit) {
      if (event.gitHubCode.isNotEmpty) {
        String aux = await _activeSession.getAuthorizationCodeGrant();

        print("El AUX --> " + aux);

        Map<String, dynamic> paco = jsonDecode(aux);

        print("PACO --> " + paco.toString());

        var grant = oauth2.AuthorizationCodeGrant.fromJson(paco);

        _client =
            await grant.handleAuthorizationResponse({"code": event.gitHubCode});

        //debugPrint("Access Token: " + _client!.credentials.accessToken);
        //print(_client!.credentials.toJson().toString());
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
        print("TO JSON -> " + grant.toJson().toString());
        await _activeSession
            .saveAuthorizationCodeGrant(jsonEncode(grant.toJson()));
        await _redirect(authorizationUrl);
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

      grant2 = oauth2.AuthorizationCodeGrant(
        githubClientID,
        authorizeURI,
        tokenURI,
        secret: githubClientSecret,
        httpClient: _JsonAcceptingHttpClient(),
      );

      Uri authorizationUrl = grant2!.getAuthorizationUrl(
        Uri.parse('http://localhost:8200/static.html'),
        scopes: githubScopes,
      );

      // Our current app URL
      final currentUri = Uri.base;

      // Generate the URL redirection to our static.html page
      final redirectUri = Uri(
        host: currentUri.host,
        scheme: currentUri.scheme,
        port: currentUri.port,
        path: '/static.html',
      );

      // Full target URL with parameters
      final authUrl = 'https://www.google.com/';

      // Open window
      _popupWin = html.window.open(
        authorizationUrl.toString(),
        "Twitch Auth",
        "width=800, height=900, scrollbars=yes",
      );

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
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows)
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

  void _login(String data) async {
    /// Parse data into an Uri to extract the token easily.
    //final receivedUri = Uri.parse(data);

    /// Get the access_token from the `Uri.fragement` (depending of the
    /// authentication service it might be contained in another
    /// property of your Uri).
    String _token = data
        .split('?')
        .firstWhere((e) => e.startsWith('code='))
        .substring('code='.length);

    print("EL PUTO DATO -> " + _token);

    /// Close the popup window
    if (_popupWin != null) {
      _popupWin!.close();
      _popupWin = null;
    }

    _client = await grant2!.handleAuthorizationResponse({"code": _token});

    debugPrint("Access Token: " + _client!.credentials.accessToken);
    print(_client!.credentials.toJson().toString());
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
