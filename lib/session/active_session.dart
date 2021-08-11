import 'package:shared_preferences/shared_preferences.dart';

class ActiveSession{
  final String _storageKey = "tranvias_prefs_";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Datos de la "Sesión Activa"
  String _token = '';

  ///
  /// Singleton Factory
  ///
  static final ActiveSession _activeSession = new ActiveSession._internal();

  factory ActiveSession() => _activeSession;

  ActiveSession._internal();

  Future<String> hasToken() async {
    if (_token.isNotEmpty) return _token;

    final SharedPreferences prefs = await _prefs;
    _token = prefs.getString(_storageKey + 'usertoken') ?? '';

    return _token;
  }

  Future<void> persistToken(String token) async {
    final SharedPreferences prefs = await _prefs;

    await prefs.setString(_storageKey + 'usertoken', token);
    _token = token;
    return;
  }

  Future<void> deleteToken() async {
    final SharedPreferences prefs = await _prefs;

    await prefs.setString(_storageKey + 'usertoken', '');
    _token = '';
    return;
  }
}