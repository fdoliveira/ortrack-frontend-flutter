import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:ortrack_frontend_flutter/dbHelper.dart';
import 'package:ortrack_frontend_flutter/motorista/motorista_service.dart';
import 'package:ortrack_frontend_flutter/infosystem/login/login_page.dart';
import 'package:ortrack_frontend_flutter/infosystem/token/token_helper.dart';
import 'package:ortrack_frontend_flutter/motorista/motorista.dart';
import 'package:ortrack_frontend_flutter/motorista/motorista_helper.dart';
import 'package:ortrack_frontend_flutter/motorista/motorista_page.dart';


class WorkspacePage extends StatefulWidget {

  @override
  _WorkspacePageState createState() => _WorkspacePageState();

}

class _WorkspacePageState extends State<WorkspacePage> {

  DbHelper dbHelper = DbHelper();

  TokenHelper tokenHelper = TokenHelper();

  List<Motorista> motoristas = List();
  MotoristaHelper motoristaHelper = MotoristaHelper();
  MotoristaService motoristaService = MotoristaService();

  @override
  void initState() {
    super.initState();
    tokenHelper.getToken().then((token) {
      if (token.token == null) {
        _showLoginPage();
      } else {
        updateList();
      }
    });
  }

  void _showLoginPage() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPage()));
    updateDB();
  }

  Future updateDB() async {
    int qtdMotoristas = await motoristaHelper.count();

    if (qtdMotoristas == 0) {
      Map motoristas = await motoristaService.list();
      await motoristaHelper.updateAll(motoristas);
    }

    this.updateList();
  }

  Future updateList() async {
    motoristaHelper.getAll().then((list) {
      //atualizando a lista de contatos na tela
      setState(() {
        motoristas = list;
      });
    });
  }

  void onLogout() async {
    await tokenHelper.clearToken();
    await motoristaHelper.removeAll();
    _showLoginPage();
  }

  //mostra o contato. Parâmetro opcional
  void _showMotoristaPage({Motorista motorista}) async {
    Motorista motoristaRet = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => MotoristaPage(motorista: motorista)));

    if (motoristaRet != null) {
      print(motoristaRet.id);
      if (motoristaRet.id != null)
        await motoristaHelper.update(motoristaRet);
      else {
        var uuid = Uuid();
        motoristaRet.id = uuid.v4();
        await motoristaHelper.save(motoristaRet);
      }

      updateList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ORTrack"),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      drawer: buildDrawer(context),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMotoristaPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: motoristas.length,
          itemBuilder: (context, index) {
            return _motoristaCard(context, index);
          }),
    );
  }

  /// Função para criação de um card de contato para lista.
  Widget _motoristaCard(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("img/person.png"))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //se não existe nome, joga vazio
                      Text(
                        motoristas[index].nome ?? "",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        motoristas[index].cpf ?? "",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _showOptions(context, index);
        });
  }

  //mostra as opções
  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            //onclose obrigatório. Não fará nada
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  //ocupa o mínimo de espaço.
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("editar",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 20.0)),
                            onPressed: () {
                              Navigator.pop(context);
                              _showMotoristaPage(motorista: motoristas[index]);
                            })),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("excluir",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 20.0)),
                            onPressed: () {
                              this.motoristaHelper.delete(motoristas[index].id);
                              updateList();
                              Navigator.pop(context);
                            }))
                  ],
                ),
              );
            },
          );
        });
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.exit_to_app, text: 'Sair', onTap: () { this.onLogout(); },),
//          _createDrawerItem(icon: Icons.event, text: 'Events',),
//          _createDrawerItem(icon: Icons.note, text: 'Notes',),
//          Divider(),
//          _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
//          _createDrawerItem(icon: Icons.face, text: 'Authors'),
//          _createDrawerItem(
//              icon: Icons.account_box, text: 'Flutter Documentation'),
//          _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
//          Divider(),
//          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
//        decoration: BoxDecoration(
//            image: DecorationImage(
//                fit: BoxFit.contain,
//                image: AssetImage('img/logo.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("ORTrack",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}