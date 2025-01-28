import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorchard/appTheme.dart';
import 'package:myorchard/home.dart';
import 'package:myorchard/manage.dart';
import 'package:myorchard/selectMap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color(0xFF627254),
          scaffoldBackgroundColor: const Color(0xFFEEEEEE),
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xFF627254)),
                  foregroundColor: WidgetStatePropertyAll(Colors.white))),
          textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 30)),
          fontFamily: 'Merriweather'),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: SafeArea(child: Home()),
      ),
    );
  }
}
