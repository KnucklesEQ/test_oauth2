import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oauth2/blocs/login/login.dart';

import 'github_card.dart';
import 'office365_card.dart';

class LoginPage extends StatefulWidget {
  final String gitHubCode;

  LoginPage({this.gitHubCode = ''});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = new LoginBloc()
      ..add(EventLoginInit(gitHubCode: widget.gitHubCode));
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => _loginBloc,
      child: BlocConsumer<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listener: (BuildContext context, LoginState state) {},
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
                    Office365Card(),
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
