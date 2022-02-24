import 'package:sqflite/sqflite.dart' as sqlite;

class SQLHelper {

  static Future<sqlite.Database> db() async {
    return sqlite.openDatabase(
        "info.db",
        version: 1,
        onCreate: (sqlite.Database database, int version) {
          database.execute(
              "CREATE TABLE note(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT)");
        }
    );
  }

//insert function
  static Future<int> insertData(String title, String description) async {
    final db = await SQLHelper.db();

    var values = {"title": title, "description": description};
    return db.insert("note", values);
  }

  //get data function
  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query("note", orderBy: "id");
    //update data
  }

  //update data
  static Future<int> updateData(int id, String title,
      String description) async {
    final db = await SQLHelper.db();
    var values = {"title": title, "description": description};
    return db.update("note", values, where: "id=?", whereArgs: [id]);
  }

  //delete data
static Future<int> deleteData(int id) async{
    final db = await SQLHelper.db();
    return db.delete("note",where: "id = ?",whereArgs: [id]);
}
}