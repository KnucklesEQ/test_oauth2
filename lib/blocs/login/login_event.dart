import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class EventLoginInit extends LoginEvent {
  @override
  String toString() => 'Event_Login_Init';
}

class EventLoginButtonPress extends LoginEvent {
  final String email;
  final String pass;

  const EventLoginButtonPress({required this.email, required this.pass});

  @override
  List<Object?> get props => [email, pass];

  @override
  String toString() => 'Event_Login_ButtonPress';
}