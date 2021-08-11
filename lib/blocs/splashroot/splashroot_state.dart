import 'package:equatable/equatable.dart';

abstract class SplashRootState extends Equatable{
  const SplashRootState();

  @override
  List<Object> get props => [];
}

class SplashRootStateUninitialized extends SplashRootState{
  @override
  String toString() => 'SplashRoot_State_Uninitialized';
}

class SplashRootStateUserNotLogged extends SplashRootState{
  @override
  String toString() => 'SplashRoot_State_UserNotLogged';
}

class SplashRootStateUserLogged extends SplashRootState{
  @override
  String toString() => 'SplashRoot_State_UserLogged';
}