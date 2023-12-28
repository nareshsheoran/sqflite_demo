// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_project_db/provider/user_provider.dart';
import 'package:sqflite_project_db/shared/model/user_model.dart';

class DetailsData extends StatefulWidget {
  final UserModel? userModel;

  const DetailsData({super.key, required this.userModel});

  @override
  State<DetailsData> createState() => _DetailsDataState();
}

class _DetailsDataState extends State<DetailsData> {
  bool isReadOnly = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .initControllerData(widget.userModel!);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (BuildContext context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          provider.clearData();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.userModel!.name),
            centerTitle: true,
            actions: [
              InkWell(
                  onTap: () {
                    setState(() {
                      isReadOnly = !isReadOnly;
                    });
                  },
                  child: const Icon(Icons.edit)),
              const SizedBox(width: 30)
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  provider.buildTitle("User Name"),
                  provider.buildFieldData(provider.nameController, "Enter Name",
                      isReadOnly, TextInputType.name),
                  provider.buildTitle("User Email"),
                  provider.buildFieldData(provider.emailController,
                      "Enter Email", isReadOnly, TextInputType.emailAddress),
                  provider.buildTitle("User Mobile"),
                  provider.buildFieldData(provider.mobileController,
                      "Enter Mobile", isReadOnly, TextInputType.phone),
                  provider.buildTitle("User Age"),
                  provider.buildFieldData(provider.ageController, "Enter Age",
                      isReadOnly, TextInputType.number),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isReadOnly
                          ? const SizedBox(width: 0)
                          : ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return buildAlertDialog(context, provider,
                                          'Confirm Update', "Update");
                                    });
                              },
                              child: const Text("Update Data")),
                      isReadOnly
                          ? const SizedBox(width: 0)
                          : const SizedBox(width: 30),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return buildAlertDialog(context, provider,
                                      'Confirm Delete', "Delete");
                                });
                          },
                          child: const Text("Delete Data"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildAlertDialog(
      BuildContext context, UserProvider provider, title, status) {
    return AlertDialog(
      title: Text(title),
      content: Text('Are you sure you want to $status this user data?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              if (status == "Update") {
                provider.updateUserData(widget.userModel!.id, context);
                Navigator.of(context).pop();
                isReadOnly = true;
                setState(() {});
              } else {
                provider.deleteUserData(widget.userModel!.id!, context);
                Navigator.of(context).pop();
                Navigator.pop(context);
              }
            },
            child: Text(status)),
      ],
    );
  }
}
