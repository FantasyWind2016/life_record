import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final int dbCurrentVersion = 1;

class DBUtil extends Object {
  final dbName = 'lr.db';
  final initSQLMap = {
    1: [
      'create table item (id INTEGER PRIMARY KEY, name TEXT, delete_flag INTEGER DEFAULT 0)',
      'create table record (id INTEGER PRIMARY KEY, item_id INTEGER, date DateTime, delete_flag INTEGER DEFAULT 0)',
    ],
    2: [
    ],
    3: [
    ],
  };

  static DBUtil instance = DBUtil();

  Future<String> initDBPath(String name) async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    print(documentDir);

    String path = join(documentDir.path, name);
    if (!Directory(dirname(path)).existsSync()) {
      try {
        Directory(dirname(path)).createSync(recursive: true);
      } catch (e) {

      }
    }
    return path;
  }

  String dbPath;
  Database _db;
  Future<Database> get db async {
    if (_db!=null) {
      return _db;
    }
    await init();
    return _db;
  }

  execInitSQL(Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion+1; i <=newVersion; i++) {
      var version1 = initSQLMap[i];
      for (var sql in version1) {
        await db.execute(sql);
      }
    }
  }
  init() async {
    dbPath = await initDBPath(dbName);
    _db = await openDatabase(dbPath, version: dbCurrentVersion, onCreate: (Database db, int version) async {
      await execInitSQL(db, 0, version);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      await execInitSQL(db, oldVersion, newVersion);
    });
  }

  close() async {
    var d = await db;
    await d.close();
  }

  insertItem(Map<String, dynamic> data) async {
    var d = await db;
    await d.transaction((trans) async {
      int id = await trans.insert('item', data);
      print('$id');
    });
  }

  Future<int> updateItem(int id, Map<String, dynamic> data) async {
    var d = await db;
    int result;
    await d.transaction((trans) async {
      result = await trans.update('item', data, where: 'id = ?', whereArgs: [id]);
      print('$result');
    });
    return result;
  }

  Future<int> deleteItem(int id) async {
    var d = await db;
    int result;
    await d.transaction((trans) async {
      result = await trans.update('item', {'delete_flag': 1}, where: 'id = ?', whereArgs: [id]);
      print('$result');
    });
    return result;
  }

  Future<int> insertRecord(Map<String, dynamic> data) async {
    var d = await db;
    int id;
    await d.transaction((trans) async {
      id = await trans.insert('record', data);
      print('$id');
    });
    return id;
  }

  Future<int> deleteRecord(int id) async {
    var d = await db;
    int resultId;
    await d.transaction((trans) async {
      resultId = await trans.update('record', {'delete_flag': 1}, where: 'id = ?', whereArgs: [id]);
      print('$resultId');
    });
    return resultId;
  }

  Future<List<Map<String, dynamic>>>queryDistinctNewestRecords(Map data) async {
    String sql = 'SELECT i.id AS item_id, i.name, r.id, r.count, r.max_date '
      + 'FROM item AS i LEFT JOIN '
      + '(SELECT id, item_id, count(date) as count, max(date) as max_date from record where delete_flag = 0 group by item_id) AS r '
      + 'ON i.id=r.item_id '
      + 'WHERE i.delete_flag = 0';
    if (data!=null && data['item_id']!=null) {
      sql += ' AND i.id = ${data['item_id']}';
    }
    var d = await db;
    return await d.rawQuery(sql);
  }

  Future<Map<String, dynamic>>queryItem(int id) async {
    var d = await db;
    var results = await d.query('item', where: 'id = ?', whereArgs: [id]);
    return results.isEmpty ? {} : results.first;
  }

  Future<List<Map<String, dynamic>>>queryItemRecords(int id) async {
    var d = await db;
    return await d.query('record', where: 'item_id = ? AND delete_flag = 0', whereArgs: [id]);
  }
}