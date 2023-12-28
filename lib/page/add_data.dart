// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_project_db/provider/user_provider.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {

  @override
  void initState() {
    super.initState();
    initDbData();
  }

  Future<void> initDbData() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).initData();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return WillPopScope(
          onWillPop: () async {
            provider.clearData();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
                title: InkWell(
                    onTap: () {
                      provider.initData();
                    },
                    child: const Text("Add Data")),
                centerTitle: true),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    provider.buildTitle("User Name"),
                    provider.buildFieldData(
                        provider.nameController, "Enter Name", false,TextInputType.name),
                    provider.buildTitle("User Email"),
                    provider.buildFieldData(
                        provider.emailController, "Enter Email", false,TextInputType.emailAddress),
                    provider.buildTitle("User Mobile"),
                    provider.buildFieldData(
                        provider.mobileController, "Enter Mobile", false,TextInputType.phone),
                    provider.buildTitle("User Age"),
                    provider.buildFieldData(
                        provider.ageController, "Enter Age", false,TextInputType.number),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              provider.insertData(context);
                              setState(() {});
                            },
                            child: const Text("Submit User Data")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
