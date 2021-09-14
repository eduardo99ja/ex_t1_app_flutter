import 'package:ex_t1_app/src/pages/roles/roles_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  RolesController _con = new RolesController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Selecciona un rol',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
          child: ListView(
            children: [
              _cardRolSeller(),
              _cardRolClient(),
            ],
          ),
        ));
  }

  Widget _cardRolSeller() => GestureDetector(
        onTap: () => _con.goToLoginPage('seller'),
        child: Column(
          children: [
            Container(
              height: 100,
              child: FadeInImage(
                image: AssetImage('assets/img/seller.png'),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Vendedor',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 25),
          ],
        ),
      );
  Widget _cardRolClient() => GestureDetector(
        onTap: () => _con.goToLoginPage('client'),
        child: Column(
          children: [
            Container(
              height: 100,
              child: FadeInImage(
                image: AssetImage('assets/img/buyer.png'),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Comprador',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 25),
          ],
        ),
      );

  void refresh() {
    setState(() {});
  }
}
