import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ortrack_frontend_flutter/infosystem/resource/resource_service.dart';
import 'package:ortrack_frontend_flutter/infosystem/token/token.dart';
import 'package:ortrack_frontend_flutter/infosystem/token/token_helper.dart';

class MotoristaService extends ResourceService {
  TokenHelper tokenHelper;

  MotoristaService() : super('motorista', 'motoristas') {
    tokenHelper = new TokenHelper();
  }

  Future<Map> list() async {
    Token token = await tokenHelper.getToken();
    http.Response response = await http.get(this.getURL(),
        headers: {'Content-Type': 'application/json', 'token': token.token});

    return json.decode(response.body);
  }
}
