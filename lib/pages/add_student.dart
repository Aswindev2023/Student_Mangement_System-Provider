import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_provider/model/user.dart';
import 'package:student_provider/provider_services/addstudent_provider.dart';
import 'package:student_provider/provider_services/user_image_provider.dart';
import 'package:student_provider/services/user_service.dart';

class AddStudent extends StatelessWidget {
  AddStudent({super.key});

  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add New Students',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          backgroundColor: const Color.fromARGB(255, 243, 219, 33),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Student Details',
                  style: TextStyle(
                      color: Color.fromARGB(255, 7, 52, 255),
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600),
                ),
                Consumer2<UserImageProvider, StudentProvider>(
                  builder:
                      (context, userImageProvider, addStudentProvider, child) {
                    return Form(
                      key: addStudentProvider.formKey,
                      child: Column(
                        children: [
                          userImageProvider.imageFile == null
                              ? ElevatedButton(
                                  onPressed: () {
                                    _pickImage(userImageProvider);
                                  },
                                  child: const Text('Select Image'),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _pickImage(userImageProvider);
                                  },
                                  child: Image.file(
                                    userImageProvider.imageFile!,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: addStudentProvider.nameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: 'Enter Name',
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                                return 'Invalid name format';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: addStudentProvider.batchController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Batch',
                              hintText: 'Enter Batch Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Batch is required';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                                return 'Invalid Batch format';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: addStudentProvider.contactController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Contact No',
                              hintText: 'Enter Contact No',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Contact No is required';
                              }
                              final cleanedPhoneNumber =
                                  value.replaceAll(RegExp(r'[^0-9]'), '');

                              if (cleanedPhoneNumber.length != 10) {
                                return 'Invalid phone number format';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          TextFormField(
                            controller: addStudentProvider.addressController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              hintText: 'Enter Address',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Student Address is required';
                              }
                              if (!RegExp(r"^[0-9A-Za-z ,.()']+$")
                                  .hasMatch(value)) {
                                return 'Invalid student Address format';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 50,
                              ),
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      alignment: Alignment.center,
                                      backgroundColor: WidgetStatePropertyAll(
                                          Color.fromARGB(255, 255, 230, 37)),
                                      minimumSize: WidgetStatePropertyAll(
                                          Size(100, 50))),
                                  onPressed: () async {
                                    if (addStudentProvider.formKey.currentState!
                                        .validate()) {
                                      var student = User();
                                      student.name = addStudentProvider
                                          .nameController.text;
                                      student.address = addStudentProvider
                                          .addressController.text;
                                      student.batch = addStudentProvider
                                          .batchController.text;
                                      student.contact = addStudentProvider
                                          .contactController.text;
                                      student.imagePath =
                                          userImageProvider.imageFile?.path ??
                                              '';
                                      //print('_student imagePath before save: ${_student.imagePath}');
                                      var result =
                                          await _userService.saveUser(student);
                                      Navigator.pop(context, result);
                                    }
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                  )),
                              const SizedBox(
                                width: 50,
                              ),
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      alignment: Alignment.center,
                                      backgroundColor: WidgetStatePropertyAll(
                                          Color.fromARGB(255, 255, 40, 40)),
                                      minimumSize: WidgetStatePropertyAll(
                                          Size(100, 50))),
                                  onPressed: () {
                                    userImageProvider.setImageFile(null);
                                    addStudentProvider.clearText();
                                    addStudentProvider.formKey.currentState!
                                        .reset();
                                  },
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(UserImageProvider userProvider) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    userProvider
        .setImageFile(pickedFile != null ? File(pickedFile.path) : null);
  }
}
