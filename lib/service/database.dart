// ignore_for_file: avoid_print
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_project_db/shared/model/user_model.dart';

class DataBaseHelperService {
  static late Database database;
  static String tableName = "user";

  Future init() async {
    var dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "user.db");

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        print("onCreate called");
        createTable(db);
      },
    );
  }

  Future createTable(Database db) async {
    await db.transaction((Transaction transaction) async {
      transaction.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, age INTEGER, mobileNumber TEXT)");
    });
    print("table created");
  }

  Future insertData(UserModel userModel) async {
    if (await isEmailAlreadyExists(userModel.email) ||
        await isMobileNumberAlreadyExists(userModel.mobileNumber)) {
      return false;
    }

    await database.transaction((txn) async {
      await txn.rawInsert(
          "INSERT INTO $tableName(name, email, age, mobileNumber) VALUES(?,?,?,?)",
          [
            userModel.name,
            userModel.email,
            userModel.age,
            userModel.mobileNumber
          ]);
    });
    print("data added");
    return true;
  }

  Future<List<UserModel>> showData() async {
    List<UserModel> userList = [];
    await database.transaction((txn) async {
      List<Map> list = await txn.rawQuery('SELECT * FROM $tableName');

      for (var element in list) {
        UserModel user = UserModel(
          id: element['id'] as int,
          name: element['name'] as String,
          email: element['email'] as String,
          age: element['age'] as int,
          mobileNumber: element['mobileNumber'] as String,
        );
        userList.add(user);
      }
    });

    return userList;
  }

  Future updateData(UserModel updatedUser) async {
    try {
      await database.transaction(
        (txn) async {
          List<Map<String, dynamic>> result = await txn.rawQuery(
            'SELECT * FROM $tableName WHERE id = ?',
            [updatedUser.id],
          );
          if (result.isNotEmpty) {
            await txn.rawUpdate(
              'UPDATE $tableName SET name = ?, email = ?, age = ?, mobileNumber = ? WHERE id = ?',
              [
                updatedUser.name,
                updatedUser.email,
                updatedUser.age,
                updatedUser.mobileNumber,
                updatedUser.id,
              ],
            );
            print("data updated");
          }
        },
        exclusive: true,
      );
      return true;
    } catch (e) {
      print("data updated error:::::$e");
    }
  }

  Future<void> deleteData(int userId) async {
    await database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM $tableName WHERE id = ?', [userId]);
    });
  }

  Future<bool> isEmailAlreadyExists(String email) async {
    List<Map> result = await database.rawQuery(
      'SELECT * FROM $tableName WHERE email = ?',
      [email],
    );

    return result.isNotEmpty;
  }

  Future<bool> isMobileNumberAlreadyExists(String mobileNumber) async {
    List<Map> result = await database.rawQuery(
      'SELECT * FROM $tableName WHERE mobileNumber = ?',
      [mobileNumber],
    );

    return result.isNotEmpty;
  }

  void closeDb() {
    database.close();
  }
}
