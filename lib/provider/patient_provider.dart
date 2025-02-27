import 'package:flutter/material.dart';
import 'package:mental_health/database/patient_db.dart';
import 'package:mental_health/model/patient.dart';

class Patientprovider with ChangeNotifier {
  List<Patient> patients = [];

  List<Patient> getPatients() => patients;

  Future<void> initData() async {
    var db = PatientDb(dbName: "patient.db");
    patients = await db.loadAllData();
    notifyListeners();
  }

  void addPatient(Patient newPatient) async {
    var db = PatientDb(dbName: "patient.db");
    int key = await db.insertData(newPatient);
    newPatient.keyID = key;
    patients.insert(0, newPatient);
    notifyListeners();
  }

  void deletePatient(int keyID) async {
    var db = PatientDb(dbName: "patient.db");
    await db.deleteData(keyID);
    patients.removeWhere((patient) => patient.keyID == keyID);
    patients = await db.loadAllData();
    notifyListeners();
  }

  void updatePatient(Patient updatedPatient) async {
    var db = PatientDb(dbName: "patient.db");
    await db.updateData(updatedPatient);
    patients = await db.loadAllData();
    notifyListeners();
  }
}
