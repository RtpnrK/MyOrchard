import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myorchard/home.dart';
import 'package:myorchard/manage.dart';
import 'package:myorchard/selectMap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body:SafeArea(
            child: Home()
            ),
        ),
    );
  }
}