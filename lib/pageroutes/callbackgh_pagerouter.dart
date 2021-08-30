import 'package:flutter/material.dart';
import 'package:test_oauth2/pages/login/login_page.dart';
import 'web_router.dart';

class CallbackGHPageRouter extends WebRouter {
  static final _route = 'callbackgh/';
  static final String _regexString = r'^callbackgh\/+$';
  static final String _regexStringWithGroup =
      r'callbackgh\/\?code=(?<cod>[^\/]+)$';

  @override
  bool matches(RouteSettings settings) =>
      (settings.name != null) ? settings.name!.startsWith(_route) : false;

  @override
  MaterialPageRoute route(RouteSettings settings) {
    assert(matches(settings));

    //Primera comprobación
    var _routeRE = RegExp(_regexStringWithGroup);
    RegExpMatch? match =
        (settings.name != null) ? _routeRE.firstMatch(settings.name!) : null;

    //Segunda comprobación
    bool _withCode;
    if (match == null) {
      _withCode = false;
      _routeRE = RegExp(_regexString);
      match =
          (settings.name != null) ? _routeRE.firstMatch(settings.name!) : null;
    } else
      _withCode = true;

    return match == null
        ? MaterialPageRoute(
            settings: settings,
            builder: (_) => LoginPage(),
          )
        : MaterialPageRoute(
            settings: settings,
            builder: (_) => LoginPage(
              gitHubCode: (_withCode) ? match!.namedGroup('cod')! : '',
            ),
          );
  }

  static Future<T?> navigate<T>({required BuildContext context}) =>
      Navigator.pushNamed<T>(context, _route + '?code=12345');

  static Future<T?> navigateAndRemove<T>({required BuildContext context}) =>
      Navigator.popAndPushNamed(context, _route);
}
