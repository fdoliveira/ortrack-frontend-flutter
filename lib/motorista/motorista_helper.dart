import 'package:ortrack_frontend_flutter/dbHelper.dart';
import 'package:sqflite/sqflite.dart';

import 'motorista.dart';

class MotoristaHelper {

  DbHelper dbHelper;

  MotoristaHelper() {
    this.dbHelper = DbHelper();
  }

  Future<List> getAll() async {
    Database db = await this.dbHelper.db;
    List listMap = await db.query(Motorista.motoristaTable);
    List<Motorista> listMotoristas = List();

    for(Map m in listMap) {
      listMotoristas.add(Motorista.fromMap(m));
    }
    return listMotoristas;
  }

  Future<Motorista> get(int id) async {
    Database db = await this.dbHelper.db;
    List<Map> maps = await db.query(
        Motorista.motoristaTable, columns: [
        Motorista.idColumn,
        Motorista.nomeColumn,
        Motorista.cpfColumn
    ], where: "${Motorista.idColumn} = ?",
        whereArgs: [id]);
    if(maps.length > 0)
      return Motorista.fromMap(maps.first);
    else
      return null;
  }

  Future<int> count() async {
    Database db = await this.dbHelper.db;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM ${Motorista.motoristaTable}"));
  }

  Future<Motorista> save(Motorista m) async {
    Database db = await this.dbHelper.db;
    await db.insert(Motorista.motoristaTable, m.toMap());
    return m;
  }

  Future<int> update(Motorista m)  async{
    Database db = await this.dbHelper.db;
    return await db.update(Motorista.motoristaTable, m.toMap(), where: "${Motorista.idColumn} = ?", whereArgs: [m.id]);
  }

  Future<int> delete(String id)  async{
    Database db = await this.dbHelper.db;
    return await db.delete(Motorista.motoristaTable, where: "${Motorista.idColumn} = ?", whereArgs: [id]);
  }

  Future<List> updateAll(Map motoristas) async {
    Database db = await this.dbHelper.db;

    List<Motorista> listMotoristas = List();

    for(Map motorista in motoristas['motoristas']) {
      Motorista motoristaAux = Motorista();
      motoristaAux.id = motorista['id'];
      motoristaAux.nome = motorista['nome'];
      motoristaAux.cpf = motorista['cpf'];

      await db.insert(Motorista.motoristaTable, motoristaAux.toMap());

      listMotoristas.add(motoristaAux);
    }

    return listMotoristas;
  }

  Future removeAll() async {
    Database db = await this.dbHelper.db;
    await db.delete(Motorista.motoristaTable, where: "1 = 1");
  }
}
