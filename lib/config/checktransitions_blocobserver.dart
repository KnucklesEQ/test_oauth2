import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

///
/// En esta clase definimos nuestro Bloc Observer, es decir, una entidad cuyos
/// métodos saltarán de forma automática cuando ocurran Transiciones de estado,
/// Eventos o Errores en nuestros blocs. Usado en un principio para log.
///
class CheckTransitionsBlocObserver extends BlocObserver{
  ///
  /// Se lanza automáticamente en cada transición de estado Bloc
  ///
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(transition.toString());
  }

  ///
  /// Se lanza automáticamente en cada evento Bloc lanzado
  ///
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('EVENTO LANZADO: ' + event.toString());
  }

  ///
  /// Se lanza de forma automática cuando ocurra un error en una transición de
  /// estado Bloc
  ///
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('$error, $stackTrace');
  }
}