// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db-student');
    var database = await openDatabase(path,
        version: 3, onCreate: _studentTable, onUpgrade: _onUpgrade);
    return database;
  }

  Future<void> _studentTable(Database database, int version) async {
    String sql =
        "CREATE TABLE Students(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,batch TEXT,contact TEXT, address TEXT, imagePath TEXT);";
    await database.execute(sql);
  }

  Future<void> _onUpgrade(
      Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      String addColumnSql = "ALTER TABLE Students ADD COLUMN  imagePath Text;";
      await database.execute(addColumnSql);
    }
  }
}
