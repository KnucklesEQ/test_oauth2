import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oauth2/blocs/login/login.dart';
import 'package:test_oauth2/pageroutes/homemain_pagerouter.dart';
import 'package:test_oauth2/widgets/my_generic_loading_indicator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginBloc _loginBloc;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _usernameError = false;
  bool _passwordError = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = new LoginBloc()..add(EventLoginInit());
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state is LoginStateSuccess) {
          HomeMainPageRouter.navigateAndRemove(context: context);
          return;
        }
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
            child: Stack(
              children: [
                Center(
                  child: Card(
                    elevation: 10,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          _userTextField(context),
                          SizedBox(height: 20),
                          _passTextField(context),
                          SizedBox(height: 20),
                          _loginButton(context),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                (state is LoginStateLoading)
                    ? MyGenericLoadingIndicator()
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _userTextField(BuildContext context) {
    return Container(
      width: 300,
      child: TextField(
        controller: _emailController,
        textInputAction: TextInputAction.next,
        style: TextStyle(fontSize: 20.0),
        decoration: _textFieldDecoration(
          context: context,
          hintText: "Dirección E-mail",
          isError: _usernameError,
        ),
      ),
    );
  }

  Widget _passTextField(BuildContext context) {
    return Container(
      width: 300,
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        style: TextStyle(fontSize: 20.0),
        decoration: _textFieldDecoration(
          context: context,
          hintText: "Contraseña",
          isError: _passwordError,
        ),
        onSubmitted: (String value) => _loginBloc.add(
          EventLoginButtonPress(
            email: _emailController.text,
            pass: _passwordController.text,
          ),
        ),
      ),
    );
  }

  InputDecoration _textFieldDecoration({
    required BuildContext context,
    required String hintText,
    required bool isError,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide: BorderSide(
          width: (isError) ? 2.0 : 1.0,
          color: (isError) ? Theme.of(context).errorColor : Colors.grey[500]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
        borderSide: BorderSide(
          width: 2.0,
          color: (isError)
              ? Theme.of(context).errorColor
              : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: 150,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => _loginBloc.add(
          EventLoginButtonPress(
            email: _emailController.text,
            pass: _passwordController.text,
          ),
        ),
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0)
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
