import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginStateUninitialized extends LoginState {
  @override
  String toString() => 'Login_State_Uninitialized';
}

class LoginStateLoading extends LoginState {
  @override
  String toString() => 'Login_State_Loading';
}

class LoginStateIdle extends LoginState {
  @override
  String toString() => 'Login_State_Idle';
}

class LoginStateGoToRemote extends LoginState {
  final String url;

  const LoginStateGoToRemote({required this.url});

  @override
  List<Object?> get props => [url];

  @override
  String toString() => 'Login_State_GoToRemote';
}

class LoginStateSuccess extends LoginState {
  @override
  String toString() => 'Login_State_Success';
}