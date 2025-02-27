import 'dart:io';
import 'package:mental_health/model/patient.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';

class PatientDb {
  final String dbName;

  PatientDb({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertData(Patient newPatient) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("patient");
    int key = await store.add(db, {
      "name": newPatient.name,
      "age": newPatient.age,
      "result": newPatient.result,
    });
    db.close();
    return key;
  }

  Future<List<Patient>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("patient");
    var snapshot = await store.find(
      db,
      finder: Finder(sortOrders: [SortOrder(Field.key, false)]),
    );
    List<Patient> patientList = [];
    for (var record in snapshot) {
      patientList.add(
        Patient(
          keyID: record.key as int,
          name: record["name"] as String,
          age: record["age"] as int,
          result: record["result"] as String,
        ),
      );
    }
    db.close();
    return patientList;
  }

  Future<void> deleteData(int keyID) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("patient");
    await store.record(keyID).delete(db);
    db.close();
  }

  Future<void> updateData(Patient updatedPatient) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("patient");
    await store.record(updatedPatient.keyID!).update(db, {
      "name": updatedPatient.name,
      "age": updatedPatient.age,
      "result": updatedPatient.result,
    });
    db.close();
  }
}
