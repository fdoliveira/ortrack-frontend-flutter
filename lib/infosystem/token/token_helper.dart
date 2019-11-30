import 'package:ortrack_frontend_flutter/infosystem/token/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenHelper {
  //singleton
  //construtor interno
  static final TokenHelper _instance = TokenHelper.internal();

  //criação do factory para retornar a instância
  factory TokenHelper() => _instance;

  //contacthelp.instance
  TokenHelper.internal();

  SharedPreferences _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs == null)
      _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  Future setToken(Token token) async {
    SharedPreferences prefsToken = await prefs;

    prefsToken.setString('token.token', token.token);
    prefsToken.setString('token.userId', token.userId);
  }

  Future<Token> getToken() async {
    Token token = Token();
    SharedPreferences prefsToken = await prefs;

    token.token = prefsToken.getString('token.token');
    token.userId = prefsToken.getString('token.userId');

    return token;
  }

  Future clearToken() async {
    SharedPreferences prefsToken = await prefs;

    prefsToken.remove('token.token');
    prefsToken.remove('token.userId');
  }
}