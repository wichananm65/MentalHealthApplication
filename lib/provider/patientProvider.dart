import 'package:flutter/material.dart';
import 'package:mental_health/model/patient.dart';

class Patientprovider with ChangeNotifier {
  List<Patient> patients = [];

  List<Patient> getPatients() {
    return patients;
  }

  void addPatient(Patient newPatient) {
    patients.add(newPatient);
  }
}
