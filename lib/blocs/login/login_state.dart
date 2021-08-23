import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginStateUninitialized extends LoginState {
  @override
  String toString() => 'Login_State_Uninitialized';
}

class LoginStateIdle extends LoginState {
  @override
  String toString() => 'Login_State_Idle';
}

class LoginStateStartLoadingGitHub extends LoginState {
  @override
  String toString() => 'Login_State_StartLoadingGitHub';
}

class LoginStateStartLoadingTwitch extends LoginState {
  @override
  String toString() => 'Login_State_StartLoadingTwitch';
}

class LoginStateEndLoadingGitHub extends LoginState {
  @override
  String toString() => 'Login_State_EndLoadingGitHub';
}

class LoginStateEndLoadingTwitch extends LoginState {
  @override
  String toString() => 'Login_State_EndLoadingTwitch';
}

class LoginStateGitHubRefreshData extends LoginState {
  final String accessToken;
  final String authToken;

  const LoginStateGitHubRefreshData({
    required this.accessToken,
    required this.authToken,
  });

  @override
  List<Object?> get props => [accessToken, authToken];

  @override
  String toString() => 'Login_State_GitHubRefreshData';
}

class LoginStateSuccess extends LoginState {
  @override
  String toString() => 'Login_State_Success';
}

class LoginStateTralari extends LoginState{}