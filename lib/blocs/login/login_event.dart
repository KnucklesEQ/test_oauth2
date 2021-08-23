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

class EventLoginGitHubButtonPress extends LoginEvent {
  @override
  String toString() => 'Event_Login_GitHubButtonPress';
}

class EventLoginTwitchButtonPress extends LoginEvent {
  @override
  String toString() => 'Event_Login_TwitchButtonPress';
}