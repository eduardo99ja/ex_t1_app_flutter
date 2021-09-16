import 'package:ex_t1_app/src/pages/client/home/client_home_page.dart';
import 'package:ex_t1_app/src/pages/credits/credits_page.dart';
import 'package:ex_t1_app/src/pages/login/login_page.dart';
import 'package:ex_t1_app/src/pages/register/register_page.dart';
import 'package:ex_t1_app/src/pages/roles/roles_page.dart';
import 'package:ex_t1_app/src/pages/seller/seller_home_page.dart';
import 'package:ex_t1_app/src/pages/seller/services/create/seller_services_create_page.dart';
import 'package:ex_t1_app/src/pages/seller/services/search/seller_services_search_page.dart';
import 'package:ex_t1_app/src/pages/seller/services/status/seller_services_status.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: 'roles',
      routes: {
        'roles': (BuildContext context) => RolesPage(),
        'credits': (BuildContext context) => CreditsPage(),
        'register': (BuildContext context) => RegisterPage(),
        'login': (BuildContext context) => LoginPage(),
        'seller/home': (BuildContext context) => SellerHomePage(),
        'seller/services/search': (BuildContext context) =>
            SellerServicesSearchPage(),
        'seller/services/create': (BuildContext context) =>
            SellerServicesCreatePage(),
        'client/home': (BuildContext context) => ClientHomePage(),
        'seller/services/list': (BuildContext context) =>
            SellerServicesStatus(),
      },
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(elevation: 0),
      ),
    );
  }
}
