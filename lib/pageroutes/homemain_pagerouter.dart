import 'package:flutter/material.dart';
import 'package:test_oauth2/pages/four04_page.dart';
import 'package:test_oauth2/pages/homemain_page.dart';
import 'web_router.dart';

class HomeMainPageRouter extends WebRouter {
  static final _route = 'homemain/';
  static final _routeRE = RegExp(r'^homemain\/+$');

  @override
  bool matches(RouteSettings settings) =>
      (settings.name != null) ? settings.name!.startsWith(_route) : false;

  @override
  MaterialPageRoute route(RouteSettings settings) {
    assert(matches(settings));
    RegExpMatch? match =
    (settings.name != null) ? _routeRE.firstMatch(settings.name!) : null;

    return match == null
        ? MaterialPageRoute(
      settings: settings,
      builder: (_) => Four04Page("Ruta desconocida: '${settings.name}'"),
    )
        : MaterialPageRoute(
      settings: settings,
      builder: (_) => HomeMainPage(),
    );
  }

  static Future<T?> navigate<T>({required BuildContext context}) =>
      Navigator.pushNamed<T>(context, _route);

  static Future<T?> navigateAndRemove<T>({required BuildContext context}) =>
      Navigator.popAndPushNamed(context, _route);
}
