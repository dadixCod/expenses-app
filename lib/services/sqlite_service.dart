import 'package:expense/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static Future<Database> initDb(String userId) async {
    String databaseName = "database_$userId.db";
    String tableName = 'Expenses';
    String path = await getDatabasesPath();
    String databasePath = join(path, databaseName);

    return openDatabase(
      databasePath,
      onCreate: (database, version) async {
        await database.execute('''
                CREATE TABLE $tableName(
                  id TEXT PRIMARY KEY,
                  amount REAL,
                  categoryName TEXT,
                  description TEXT,
                  date INTEGER
            )''');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final db = await SqliteService.initDb(userId);
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final db = await SqliteService.initDb(userId);
    List<Map<String, dynamic>> result = await db.query(table);
    print('Query result: $result');
    return result;
  }

  static Future<void> clearDatabase() async {
    String path = await getDatabasesPath();
    String databasePath = join(path, 'database.db');
    await deleteDatabase(databasePath);
    print("Data cleared");
  }

  static Future<void> deleteExpense(Expense expense) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final db = await SqliteService.initDb(userId);
    await db.delete('Expenses', where: 'id = ?', whereArgs: [expense.id]);
  }
}
