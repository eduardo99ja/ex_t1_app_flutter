import 'dart:async';

import 'package:ex_t1_app/src/models/compra.dart';
import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/pages/seller/services/info/seller_services_info_page.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ClientServicesOrdersTab extends StatefulWidget {
  const ClientServicesOrdersTab({Key? key}) : super(key: key);

  @override
  _ClientServicesOrdersTabState createState() => _ClientServicesOrdersTabState();
}

class _ClientServicesOrdersTabState extends State<ClientServicesOrdersTab> {
  List<Compra>? _services;
  StreamSubscription<Event>? _addServicio;
  StreamSubscription<Event>? _changeService;
  final _servicesRef = FirebaseDatabase.instance
      .reference()
      .child('compras')
      .orderByChild('statusCompra')
      .equalTo('confirmada');
  final _dbRef = FirebaseDatabase.instance.reference().child('compras');

  // AuthProvider

  @override
  void initState() {
    super.initState();
    _services = [];
    _addServicio = _servicesRef.onChildAdded.listen(_agregarService);
    _changeService = _servicesRef.onChildChanged.listen(_updateServices);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ListView.builder(
            itemCount: _services!.length,
            padding: EdgeInsets.only(top: 12.0),
            itemBuilder: (BuildContext context, int position) {
              return Column(
                children: [
                  Divider(
                    height: 7.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${_services![position].servicio!.name}',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${_services![position].servicio!.description}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          leading: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 17.0,
                                child: Text(
                                  '${position + 1}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '\$${_services![position].servicio!.price}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _agregarService(Event event) {
    setState(() {
      _services!.add(Compra.fromSnapshot(event.snapshot));
    });
  }

  void _updateServices(Event event) {
    var oldService = _services!.singleWhere((service) => service.id == event.snapshot.key);
    setState(() {
      _services?[_services!.indexOf(oldService)] = Compra.fromSnapshot(event.snapshot);
    });
  }
}
