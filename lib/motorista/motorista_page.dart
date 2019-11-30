import 'package:flutter/material.dart';

import 'motorista.dart';

class MotoristaPage extends StatefulWidget {

  Motorista motorista;

  //construtor que inicia o contato.
  //Entre chaves porque é opcional.
  MotoristaPage({this.motorista});

  @override
  _MotoristaPageState createState() => _MotoristaPageState();
}

class _MotoristaPageState extends State<MotoristaPage> {

  Motorista _editedMotorista;
  bool _userEdited;

  //para garantir o foco no nome
  final _nomeFocus = FocusNode();

  //controladores
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //acessando o contato definido no widget(ContactPage)
    //mostrar se ela for privada
    if (widget.motorista == null)
      _editedMotorista = Motorista();
    else {
      _editedMotorista = Motorista.fromMap(widget.motorista.toMap());
      nomeController.text = _editedMotorista.nome;
      cpfController.text = _editedMotorista.cpf;
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited != null &&_userEdited) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Abandonar alteração?"),
          content: Text("Os dados serão perdidos."),
          actions: <Widget>[
            FlatButton(
                child: Text("cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            FlatButton(
              child: Text("sim"),
              onPressed: () {
                //desempilha 2x
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )

          ]
          ,
        );
      });
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    //com popup de confirmação
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            title: Text(_editedMotorista.nome ?? "Novo motorista"),
            centerTitle: true
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedMotorista.nome != null && _editedMotorista.nome.isNotEmpty)
              Navigator.pop(context, _editedMotorista);
            else
              FocusScope.of(context).requestFocus(_nomeFocus);
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.lightBlue,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nomeController,
                focusNode: _nomeFocus,
                decoration: InputDecoration(
                    labelText: "Nome"
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedMotorista.nome = text;
                  });
                },
              ),
              TextField(
                controller: cpfController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "CPF"
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedMotorista.cpf = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}