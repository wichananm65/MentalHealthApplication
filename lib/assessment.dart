import 'package:flutter/material.dart';

class Assessment extends StatefulWidget {
  const Assessment({super.key});

  @override
  State<Assessment> createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 163, 51, 183),
          title: Text("แบบประเมิน"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: const Text('ชื่อ-นามสกุล')),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    autofocus: true,
                    controller: nameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: const Text('อายุ')),
                    autofocus: true,
                    controller: nameController,
                  ),
                ],
              ),
            )));
  }
}
