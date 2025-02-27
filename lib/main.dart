import 'package:flutter/material.dart';
import 'package:mental_health/assessment.dart';
import 'package:mental_health/model/patient.dart';
import 'package:mental_health/provider/patient_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return Patientprovider();
          })
        ],
        child: MaterialApp(
          title: 'แอปพลิเคชันสุขภาพจิต',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'แอปพลิเคชันสุขภาพจิต'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 163, 51, 183),
        title: Text(widget.title),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Assessment()),
              );

              if (result == true) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.assignment),
            color: Colors.white,
            iconSize: 30,
          ),
        ],
      ),
      body: Consumer(
        builder: (context, Patientprovider provider, Widget? child) {
          int itemCount = provider.patients.length;
          if (itemCount == 0) {
            return Center(
              child: Text(
                "ไม่มีผู้ป่วย",
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, int index) {
                Patient data = provider.patients[index];
                return Card(
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Text(data.keyID.toString()),
                        ),
                      ),
                      title: Text(data.name),
                      subtitle: Text(data.result.toString()),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
