import 'package:sqflite/sqflite.dart';
import 'database_connection.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  //insert student
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //read all record
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //READ SINGLE DATA
  readDataById(table, userId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [userId]);
  }

  // UPDATE
  updateData(table, data) async {
    try {
      // print('Updating data in $table: $data');
      var connection = await database;
      return await connection
          ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
    } catch (e) {
      //print('Error updating data:$e');
      return null;
    }
  }

  //Delete Data
  deleteDataById(table, userId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where Id=$userId");
  }
}
