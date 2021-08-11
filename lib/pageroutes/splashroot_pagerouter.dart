import 'package:flutter/material.dart';
import 'package:test_oauth2/pages/splashroot_page.dart';

import 'web_router.dart';

class SplashRootPageRouter extends WebRouter {
  static final _route = '/';

  @override
  bool matches(RouteSettings settings) =>
      settings.name == null ||
      settings.name!.isEmpty ||
      settings.name == _route;

  @override
  MaterialPageRoute route(RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (_) => SplashRootPage(),
      );

  static Future<T?> navigate<T>({required BuildContext context}) =>
      Navigator.pushNamed<T>(context, _route);

  static Future<T?> navigateAndRemove<T>({required BuildContext context}) =>
      Navigator.popAndPushNamed(context, _route);
}
