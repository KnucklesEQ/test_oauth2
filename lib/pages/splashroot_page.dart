import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oauth2/blocs/splashroot/splashroot.dart';
import 'package:test_oauth2/pageroutes/login_pagerouter.dart';
import 'package:test_oauth2/widgets/my_generic_loading_indicator.dart';

class SplashRootPage extends StatefulWidget {
  @override
  _SplashRootPageState createState() => _SplashRootPageState();
}

class _SplashRootPageState extends State<SplashRootPage> {
  late final SplashRootBloc _splashRootBloc;

  @override
  void initState() {
    super.initState();
    _splashRootBloc = new SplashRootBloc()..add(EventSplashRootInitApp());
  }

  @override
  void dispose() {
    super.dispose();
    _splashRootBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _splashRootBloc,
      listener: (BuildContext context, SplashRootState state) {
        if (state is SplashRootStateUserNotLogged) {
          LoginPageRouter.navigateAndRemove(context: context);
          return;
        }
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Container(
            width: 250,
            height: 250,
            child: FittedBox(
              fit: BoxFit.fill,
              child: MyGenericLoadingIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
