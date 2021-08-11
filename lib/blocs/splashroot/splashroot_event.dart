import 'package:equatable/equatable.dart';

abstract class SplashRootEvent extends Equatable{
  const SplashRootEvent();

  @override
  List<Object> get props => [];
}

class EventSplashRootInitApp extends SplashRootEvent{
  @override
  String toString() => 'Event_SplashRoot_InitApp';
}