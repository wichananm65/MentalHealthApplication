import 'package:flutter/material.dart';
import 'question.dart';

class Assessment extends StatefulWidget {
  const Assessment({super.key});

  @override
  State<Assessment> createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  List<int?> answers = List<int?>.filled(questions.length, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 163, 51, 183),
        title: const Text("แบบประเมิน",
            style: TextStyle(color: Colors.white, fontSize: 20)),
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
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'อายุ',
                ),
                keyboardType: TextInputType.number,
                controller: ageController,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกอายุ' : null,
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
                            style: const TextStyle(
                              fontSize: 18,
                            )),
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
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("ผลการประเมิน"),
                        content: Text(
                          "คะแนนของคุณ: $score\n\n$result",
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
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
