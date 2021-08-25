import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oauth2/blocs/login/login.dart';
import 'package:uni_links/uni_links.dart' as uni;

import 'github_card.dart';
import 'twitch_card.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginBloc _loginBloc;
  late final linkStream;
  @override
  void initState() {
    super.initState();
    _loginBloc = new LoginBloc()..add(EventLoginInit());
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
    linkStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => _loginBloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listener: (BuildContext context, LoginState state) {

        },
        builder: (BuildContext context, LoginState state) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF004BA0),
                    const Color(0xFF1976D2),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Center(
                child: Wrap(
                  children: [
                    GitHubCard(),
                    TwitchCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
