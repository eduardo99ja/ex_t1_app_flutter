import 'package:ex_t1_app/src/pages/register/register_page.dart';
import 'package:ex_t1_app/src/pages/roles/roles_page.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App ',
      initialRoute: 'register',
      routes: {
        'roles': (BuildContext context) => RolesPage(),
        'register': (BuildContext context) => RegisterPage(),
      },
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(elevation: 0),
      ),
    );
  }
}
