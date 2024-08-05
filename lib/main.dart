import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:student_provider/provider_services/addstudent_provider.dart';
import 'package:student_provider/provider_services/home_provider.dart';
import 'package:student_provider/provider_services/user_image_provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
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
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 249, 255, 71)),
        ),
        home: const Homepage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
