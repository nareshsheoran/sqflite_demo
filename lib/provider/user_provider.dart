import 'package:flutter/material.dart';
import 'package:sqflite_project_db/service/database.dart';
import 'package:sqflite_project_db/shared/model/user_model.dart';

class UserProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<UserModel> userList = [];

  DataBaseHelperService dataBaseHelperService = DataBaseHelperService();

  initControllerData(UserModel userModel) {
    nameController.text = userModel.name;
    emailController.text = userModel.email;
    mobileController.text = userModel.mobileNumber;
    ageController.text = userModel.age.toString();
  }

  initData() async {
    await dataBaseHelperService.init();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  showSnackBarDialog(context) {
    if (nameController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user name");
      return true;
    } else if (emailController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user email");
      return true;
    } else if (!isValidEmail(emailController.text.trim())) {
      showSnackBar(context, "Please enter user valid email");
      return true;
    } else if (mobileController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user mobile number");
      return true;
    } else if (mobileController.text.trim().length < 10) {
      showSnackBar(context, "User mobile number should be 10 digits");
      return true;
    } else if (ageController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter user age");
      return true;
    } else {
      return false;
    }
  }

  insertData(context) async {
    if (showSnackBarDialog(context)) {
      return;
    }
    UserModel userModel = UserModel(
        name: nameController.text,
        email: emailController.text,
        age: int.parse(ageController.text),
        mobileNumber: mobileController.text);

    bool insertionResult = await dataBaseHelperService.insertData(userModel);

    if (insertionResult) {
      clearData();
      notifyListeners();
      showSnackBar(context, "User data added successfully");
      getUserData();
    } else {
      if (await dataBaseHelperService.isEmailAlreadyExists(userModel.email)) {
        showSnackBar(context, 'Data with the same email already exists.');
      } else if (await dataBaseHelperService
          .isMobileNumberAlreadyExists(userModel.mobileNumber)) {
        showSnackBar(
            context, 'Data with the same mobile number already exists.');
      } else {
        showSnackBar(context, 'Failed to add new user data.');
      }
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      context, title) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(title), duration: const Duration(seconds: 1)));
  }

  updateUserData(id, context) async {
    if (showSnackBarDialog(context)) {
      return;
    }
    UserModel userModel = UserModel(
        id: id,
        name: nameController.text,
        email: emailController.text,
        age: int.parse(ageController.text),
        mobileNumber: mobileController.text);
    await dataBaseHelperService.updateData(userModel);
    showSnackBar(context, "User data updated successfully");
  }

  getUserData() async {
    userList = await dataBaseHelperService.showData();
    notifyListeners();
  }

  deleteUserData(int id, context) async {
    await dataBaseHelperService.deleteData(id);
    showSnackBar(context, "User data deleted successfully");
  }

  closeDb() {
    dataBaseHelperService.closeDb();
  }

  clearData() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    ageController.clear();
  }

  Widget buildTitle(title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildFieldData(controller, hintText, isReadOnly, keyBoardType) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: keyBoardType,
            readOnly: isReadOnly,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
