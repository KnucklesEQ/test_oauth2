import 'package:shared_preferences/shared_preferences.dart';

class ActiveSession {
  final String _storageKey = "testoauth_";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Datos de la "Sesión Activa"
  String _jsonGrant = '';

  ///
  /// Singleton Factory
  ///
  static final ActiveSession _activeSession = new ActiveSession._internal();

  factory ActiveSession() => _activeSession;

  ActiveSession._internal();

  Future<String> getAuthorizationCodeGrant() async {
    if (_jsonGrant.isNotEmpty) return _jsonGrant;

    final SharedPreferences prefs = await _prefs;
    _jsonGrant = prefs.getString(_storageKey + 'grant') ?? '';

    return _jsonGrant;
  }

  Future<void> saveAuthorizationCodeGrant(String grant) async {
    final SharedPreferences prefs = await _prefs;

    await prefs.setString(_storageKey + 'grant', grant);
    _jsonGrant = grant;
    return;
  }

  Future<void> deleteAuthorizationCodeGrant() async {
    final SharedPreferences prefs = await _prefs;

    await prefs.setString(_storageKey + 'grant', '');
    _jsonGrant = '';
    return;
  }
}
