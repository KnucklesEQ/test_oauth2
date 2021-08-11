import 'package:bloc/bloc.dart';
import 'package:test_oauth2/session/active_session.dart';
import 'splashroot.dart';

class SplashRootBloc extends Bloc<SplashRootEvent, SplashRootState> {
  ActiveSession _activeSession = new ActiveSession();

  SplashRootBloc() : super(SplashRootStateUninitialized());

  @override
  Stream<SplashRootState> mapEventToState(SplashRootEvent event) async* {
    if (event is EventSplashRootInitApp) {
      String tokenSession = await _activeSession.hasToken();

      if (tokenSession.isEmpty)
        yield SplashRootStateUserNotLogged();
      else
        yield SplashRootStateUserLogged();

      return;
    }
  }
}
