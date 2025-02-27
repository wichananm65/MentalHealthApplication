import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mental_health/model/patient.dart';
import 'package:mental_health/provider/patient_provider.dart';
import 'question.dart';

class Edit extends StatefulWidget {
  final Patient? patientToEdit;

  const Edit({super.key, this.patientToEdit});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  List<int?> answers = List<int?>.filled(questions.length, null);

  @override
  void initState() {
    super.initState();
    if (widget.patientToEdit != null) {
      nameController.text = widget.patientToEdit!.name;
      ageController.text = widget.patientToEdit!.age.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "แก้ไข",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 51, 183),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("คุณแน่ใจว่าต้องการลบใช่หรือไม่"),
                  actions: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                      ),
                      child: const Text("ยกเลิก",
                          style: TextStyle(color: Colors.green)),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        final provider = Provider.of<Patientprovider>(context,
                            listen: false);
                        provider.deletePatient(widget.patientToEdit!.keyID!);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(true);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text("ยืนยัน",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ชื่อ-นามสกุล',
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อน ชื่อ และนามสกุล";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'อายุ',
                ),
                keyboardType: TextInputType.number,
                controller: ageController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'กรุณากรอกอายุ';
                  if (int.tryParse(value) == null) return 'กรุณากรอกตัวเลข';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ...questions.asMap().entries.map((entry) {
                int index = entry.key;
                String question = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${index + 1}: $question",
                            style: const TextStyle(fontSize: 18)),
                        Column(
                          children: options.entries.map((option) {
                            return RadioListTile<int>(
                              title: Text(option.value),
                              value: option.key,
                              groupValue: answers[index],
                              onChanged: (value) {
                                setState(() {
                                  answers[index] = value;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate() &&
                      !answers.contains(null)) {
                    int score = calculateScore(answers);
                    String result = getResultInterpretation(score);
                    final provider =
                        Provider.of<Patientprovider>(context, listen: false);

                    if (widget.patientToEdit != null) {
                      widget.patientToEdit!.name = nameController.text;
                      widget.patientToEdit!.age = int.parse(ageController.text);
                      widget.patientToEdit!.result = result;
                      provider.updatePatient(widget.patientToEdit!);
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("ผลการประเมิน"),
                        content: Text(
                          "คะแนนของคุณ: $score\n\n$result",
                          style: const TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("ตกลง"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("กรุณาตอบทุกข้อและกรอกข้อมูลให้ครบถ้วน")),
                    );
                  }
                },
                child: const Text("ส่งแบบประเมิน"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
