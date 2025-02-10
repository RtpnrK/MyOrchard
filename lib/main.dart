import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/components/nav_bar.dart';
import 'package:myorchard/pages/activities.dart';
import 'package:myorchard/pages/profile.dart';
import 'package:myorchard/providers/profile_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(412, 917),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Color.fromRGBO(98, 114, 84, 1),
                  primary: Color.fromRGBO(98, 114, 84, 1),
                  secondary: Color.fromRGBO(128, 157, 60, 1),
                  surface: Color.fromRGBO(238, 238, 238, 1),
                ),
                textTheme: TextTheme(
                  titleLarge: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(66, 65, 65, 1)),
                  labelLarge: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      ),
                  headlineLarge: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(98, 114, 84, 1)),
                )),
            home: child,
          );
        },
        child: const NavBar(),
      ),
    );
  }
}
