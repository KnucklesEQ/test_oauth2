import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pageroutes/web_router.dart';

class WebTestOauth2 extends StatelessWidget {
  //La tecla Esc realiza por defecto un Navigator.of(context).pop(), con esto
  //quitamos esta propiedad y así no hay que gestionar el tema en cada pantalla
  final shortcuts = Map.of(WidgetsApp.defaultShortcuts)
    ..remove(LogicalKeySet(LogicalKeyboardKey.escape));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      shortcuts: shortcuts,
      debugShowCheckedModeBanner: false,
      title: "Test OAuth 2 with GitHub",
      onGenerateRoute: WebRouter.onGenerateRoute,
    );
  }
}