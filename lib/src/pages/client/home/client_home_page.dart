import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({Key? key}) : super(key: key);

  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
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
        child: Text('Cliente'),
      ),
    );
  }
}
