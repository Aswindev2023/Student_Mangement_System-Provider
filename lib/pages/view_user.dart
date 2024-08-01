//View user

import 'package:flutter/material.dart';

import 'dart:io';

import 'package:student_provider/model/user.dart';

class ViewUser extends StatelessWidget {
  final User user;
  const ViewUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 219, 33),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student Details',
            style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 47, 33, 243),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: CircleAvatar(
              radius: 75,
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.file(
                  File(user.imagePath ?? ''),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Name :',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 25, 29, 255),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  user.name ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Batch :',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 25, 29, 255),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  user.batch ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Contact :',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 25, 29, 255),
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  user.contact ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Address :',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 25, 29, 255),
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  user.address ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
