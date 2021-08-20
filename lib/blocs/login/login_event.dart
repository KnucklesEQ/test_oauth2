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
  @override
  String toString() => 'Event_Login_ButtonPress';
}
