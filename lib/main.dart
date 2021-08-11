import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'config/checktransitions_blocobserver.dart';
import 'web_testoauth2.dart';

void main() {
  //Si ejecutamos alguna función async antes de runApp, tenemos que meter esta
  //línea dentro del main para indicarle que espere a que se completen estas
  //funciones
  WidgetsFlutterBinding.ensureInitialized();

  //Montamos el Bloc Observer, con el que vamos a registrar todas las
  //Transiciones entre estados que ocurran en los Blocs que vayamos montando
  Bloc.observer = CheckTransitionsBlocObserver();

  runApp(WebTestOauth2());
}
