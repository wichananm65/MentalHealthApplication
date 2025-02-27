import 'package:flutter/material.dart';
import 'package:mental_health/database/patient_db.dart';
import 'package:mental_health/model/patient.dart';

class Patientprovider with ChangeNotifier {
  List<Patient> patients = [];

  List<Patient> getPatients() {
    return patients;
  }

  void addPatient(Patient newPatient) async {
    var db = PatientDb(dbName: "patient.db");
    await db.InsertData(newPatient);
    await db.loadAllData();
    patients.insert(0, newPatient);
    notifyListeners();
  }
}
