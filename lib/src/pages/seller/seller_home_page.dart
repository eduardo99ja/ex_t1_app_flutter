import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = new AuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              await _authProvider.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'roles', (route) => false);
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: Container(
        child: Text('Vendedor'),
      ),
    );
  }
}
