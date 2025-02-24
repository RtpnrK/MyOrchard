import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myorchard/pages/maps.dart';
import 'package:myorchard/providers/activity_provider.dart';
import 'package:myorchard/providers/chats_provider.dart';
import 'package:myorchard/providers/map_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => ActivityProvider(0)),
        ChangeNotifierProvider(create: (context) => ChatsProvider(0)),
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
                  bodySmall: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(115, 111, 111, 1)),
                  bodyLarge: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyMedium: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(115, 111, 111, 1)),
                ),
                fontFamily: 'Mitr',
                cardTheme: CardTheme(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22.5))),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromRGBO(98, 114, 84, 1)),
                        iconColor: WidgetStatePropertyAll(Colors.white),
                        foregroundColor:
                            WidgetStatePropertyAll(Colors.white)))),
            home: child,
          );
        },
        child: const Maps(),
      ),
    );
  }
}
