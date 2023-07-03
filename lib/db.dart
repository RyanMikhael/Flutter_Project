import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase{
  late String path;
  late Database database;

  Future<String> init () async{
    var databasePath = await getDatabasesPath();
    path = join(databasePath, 'demo.db');

    return path;
  }

  Future<Database> open() async {
    path = await init();
    database = await openDatabase(path, version: 1, onCreate: (Database db, int version ) async {
      await db.execute('CREATE TABLE Usuario(id INTEGER PRIMARY KEY, nome TEXT UNIQUE, email TEXT UNIQUE, password TEXT, latitude REAL, longitude REAL);');
      await db.execute('CREATE TABLE Contatos(id_contato INTEGER PRIMARY KEY, nome TEXT, email TEXT, id_usuario INTEGER, FOREIGN KEY(id_usuario) REFERENCES Usuario(id));');
    });

    return database;

  }


}