import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ortrack_frontend_flutter/infosystem/resource/resource_service.dart';
import 'package:ortrack_frontend_flutter/infosystem/token/token.dart';

import 'login.dart';

class LoginService extends ResourceService {
  LoginService() : super('token', 'tokens');

  Future<Map> login(Login loginTeste) async {
    http.Response response = await http.post(this.getURL(),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'domain_name': loginTeste.domainName, 'username': loginTeste.username, 'password': loginTeste.password}));
    return json.decode(response.body);
  }
}
