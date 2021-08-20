import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:test_oauth2/pages/four04_page.dart';

import 'login_pagerouter.dart';
import 'splashroot_pagerouter.dart';

abstract class WebRouter {
  bool matches(RouteSettings settings);

  MaterialPageRoute route(RouteSettings settings);

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('Ruta recibida -> ${settings.name}');
    late final WebRouter? router;

    router = routers.firstWhereOrNull((r) => r.matches(settings));

    return (router != null)
        ? router.route(settings)
        : MaterialPageRoute(
            settings: settings,
            builder: (_) => Four04Page("Ruta desconocida: '${settings.name}'"),
          );
  }

  static final routers = [
    // start with most specific one first
    LoginPageRouter(),
    SplashRootPageRouter(),
  ];
}
