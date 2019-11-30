import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ortrack_frontend_flutter/motorista/motorista.dart';

class DbHelper {
  //singleton
  //construtor interno
  static final DbHelper _instance = DbHelper.internal();

  //criação do factory para retornar a instância
  factory DbHelper() => _instance;

  //contacthelp.instance
  DbHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null)
      _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "ortrack.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db.execute(
              "CREATE TABLE ${Motorista.motoristaTable}("
                  "${Motorista.idColumn}   TEXT PRIMARY KEY, "
                  "${Motorista.nomeColumn} TEXT NOT NULL, "
                  "${Motorista.cpfColumn}  TEXT NOT NULL"
              ")");
        });
  }

  Future close() async{
    Database database = await db;
    database.close();
  }
}