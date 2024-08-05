import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_provider/model/user.dart';
import 'package:student_provider/provider_services/addstudent_provider.dart';
import 'package:student_provider/provider_services/user_image_provider.dart';
import 'package:student_provider/services/user_service.dart';

class EditUser extends StatelessWidget {
  final User user;
  const EditUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Student Details',
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              Consumer2<UserImageProvider, StudentProvider>(
                builder:
                    (context, userImageProvider, editStudentProvider, child) {
                  editStudentProvider.nameController.text = user.name ?? '';
                  editStudentProvider.batchController.text = user.batch ?? '';
                  editStudentProvider.contactController.text =
                      user.contact ?? '';
                  editStudentProvider.addressController.text =
                      user.address ?? '';

                  return Form(
                    key: editStudentProvider.formKey,
                    child: Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: userImageProvider.imageFile != null
                                  ? Image.file(
                                      userImageProvider.imageFile!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : (user.imagePath != null
                                      ? Image.file(
                                          File(user.imagePath!),
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 150,
                                        )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            _pickImage(userImageProvider);
                          },
                          child: const Text('Select Image'),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: editStudentProvider.nameController,
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
                          controller: editStudentProvider.batchController,
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
                          controller: editStudentProvider.contactController,
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
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: editStudentProvider.addressController,
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
                        const SizedBox(height: 20.0),
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
                                  Color.fromARGB(255, 255, 230, 37),
                                ),
                                minimumSize: WidgetStatePropertyAll(
                                  Size(100, 50),
                                ),
                              ),
                              onPressed: () async {
                                _updateUser(context, user, editStudentProvider,
                                    userImageProvider);
                                userImageProvider.setImageFile(null);
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            ElevatedButton(
                              style: const ButtonStyle(
                                alignment: Alignment.center,
                                backgroundColor: WidgetStatePropertyAll(
                                  Color.fromARGB(255, 255, 40, 40),
                                ),
                                minimumSize: WidgetStatePropertyAll(
                                  Size(100, 50),
                                ),
                              ),
                              onPressed: () {
                                userImageProvider.setImageFile(null);
                                editStudentProvider.clearText();
                                editStudentProvider.formKey.currentState!
                                    .reset();
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(UserImageProvider userImageProvider) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    userImageProvider
        .setImageFile(pickedFile != null ? File(pickedFile.path) : null);
  }

  Future<void> _updateUser(
    BuildContext context,
    User user,
    StudentProvider editStudentProvider,
    UserImageProvider userImageProvider,
  ) async {
    if (editStudentProvider.formKey.currentState!.validate()) {
      var updatedUser = user;
      updatedUser.name = editStudentProvider.nameController.text;
      updatedUser.address = editStudentProvider.addressController.text;
      updatedUser.batch = editStudentProvider.batchController.text;
      updatedUser.contact = editStudentProvider.contactController.text;

      if (userImageProvider.imageFile != null) {
        updatedUser.imagePath = userImageProvider.imageFile!.path;
      }

      var result = await UserService().updateUser(updatedUser);

      if (result != null) {
        Navigator.pop(context, true);
      } else {
        log('update failed');
      }
    }
  }
}
