import 'package:flutter/material.dart';
import 'package:mental_health/assessment.dart';
import 'package:mental_health/edit.dart';
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
        ChangeNotifierProvider(create: (context) => Patientprovider()),
      ],
      child: MaterialApp(
        title: 'แอปพลิเคชันสุขภาพจิต',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'แอปพลิเคชันสุขภาพจิต'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Patientprovider>(context, listen: false).initData();
    });
    searchController.addListener(() {
      setState(() {
        query = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 163, 51, 183),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหา',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              ),
            ),
          ),
        ),
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
            icon: const Icon(
              Icons.assignment,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Consumer<Patientprovider>(
        builder: (context, provider, child) {
          List<Patient> filteredPatients = provider.patients
              .where((patient) =>
                  patient.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

          int itemCount = filteredPatients.length;
          if (itemCount == 0) {
            return Center(
              child: Text(
                "ไม่มีผู้ป่วยที่ตรงกับคำค้น",
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: itemCount,
              itemBuilder: (context, int index) {
                Patient data = filteredPatients[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Edit(
                                    patientToEdit: data,
                                  )));
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.deepPurple,
                              child: FittedBox(
                                child: Text(
                                  data.keyID.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${data.name} อายุ ${data.age} ปี",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data.result.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      const Color.fromARGB(255, 148, 21, 245)),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
