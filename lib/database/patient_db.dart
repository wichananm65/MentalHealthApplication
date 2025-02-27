import 'dart:io';

import 'package:mental_health/model/patient.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

class PatientDb {
  String? dbName;

  PatientDb({this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> InsertData(Patient newPatient) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("patient");
    var keyID = store.add(db, {
      "name": newPatient.name,
      "age": newPatient.age,
      "result": newPatient.result,
    });
    db.close();
    return keyID;
  }

  loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("patient");
    var snapshot = await store.find(db);
  }
}
