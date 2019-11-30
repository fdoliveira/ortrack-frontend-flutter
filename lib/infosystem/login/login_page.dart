import 'dart:io';


import 'package:flutter/material.dart';
import 'package:ortrack_frontend_flutter/infosystem/token/token.dart';
import 'package:ortrack_frontend_flutter/infosystem/login/login_service.dart';
import 'package:ortrack_frontend_flutter/infosystem/token/token_helper.dart';

import 'login.dart';

class LoginPage extends StatefulWidget {

  Login login;

  //construtor que inicia o contato.
  //Entre chaves porque é opcional.
  LoginPage({this.login});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //controladores
  TextEditingController domainController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //acessando o contato definido no widget(ContactPage)
    //mostrar se ela for privada
    if (widget.login == null) {
      widget.login = Login();
    }
  }

  Future<void> onLogin() async {
    LoginService loginService = LoginService();
    if (widget.login == null) {
      widget.login = Login();
      widget.login.domainName = domainController.text;
      widget.login.username = usernameController.text;
      widget.login.password = passwordController.text;
    }
    Map tokenData = await loginService.login(widget.login);
    Token token = Token();
    token.token = tokenData['token']['id'];
    token.userId = tokenData['token']['user_id'];
    TokenHelper tokenHelper = TokenHelper();
    await tokenHelper.setToken(token);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Cuppertino', fontSize: 20.0);

    final domainField = TextField(
      controller: domainController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Domínio",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (text) {
        this.widget.login.domainName = text;
      },
    );

    final usernameField = TextField(
      controller: usernameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Usuário",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (text) {
        this.widget.login.username = text;
      },
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Senha",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (text) {
        this.widget.login.password = text;
      },
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          onLogin();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                  child: Image.asset(
                    "img/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 15.0),
                domainField,
                SizedBox(height: 15.0),
                usernameField,
                SizedBox(height: 15.0),
                passwordField,
                SizedBox(
                  height: 10.0,
                ),
                loginButon,
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}