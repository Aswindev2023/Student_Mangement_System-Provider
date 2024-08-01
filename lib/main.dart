// ignore_for_file: prefer_const_constructors, unnecessary_string_escapes, library_private_types_in_public_api, avoid_print, unused_element, use_build_context_synchronously
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:student_provider/provider_services/addstudent_provider.dart';
import 'package:student_provider/provider_services/user_image_provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserImageProvider>(
          create: (_) => UserImageProvider(),
        ),
        ChangeNotifierProvider<StudentProvider>(
          create: (_) => StudentProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 249, 255, 71)),
        ),
        home: Homepage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
