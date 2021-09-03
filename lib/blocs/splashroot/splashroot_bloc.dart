import 'package:bloc/bloc.dart';
import 'splashroot.dart';

class SplashRootBloc extends Bloc<SplashRootEvent, SplashRootState> {
  SplashRootBloc() : super(SplashRootStateUninitialized());

  @override
  Stream<SplashRootState> mapEventToState(SplashRootEvent event) async* {
    if (event is EventSplashRootInitApp) {
      yield SplashRootStateUserNotLogged();

      return;
    }
  }
}
