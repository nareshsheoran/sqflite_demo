import 'package:flutter/material.dart';
import 'package:sqflite_project_db/page/add_data.dart';
import 'package:sqflite_project_db/page/show_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDataPage()));
                },
                child: const Text("Add User Data")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShowDataPage()));
                },
                child: const Text("Show User Data")),
          ],
        ),
      ),
    );
  }
}
