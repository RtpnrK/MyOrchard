import 'package:flutter/material.dart';
import 'package:myorchard/home.dart';
import 'package:myorchard/selectMap.dart';

void main() {
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