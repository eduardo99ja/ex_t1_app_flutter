import 'dart:async';

import 'package:ex_t1_app/src/models/compra.dart';
import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/pages/seller/services/info/seller_services_info_page.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ClientServicesCartTab extends StatefulWidget {
  const ClientServicesCartTab({Key? key}) : super(key: key);

  @override
  _ClientServicesCartTabState createState() => _ClientServicesCartTabState();
}

class _ClientServicesCartTabState extends State<ClientServicesCartTab> {
  List<Compra>? _services;
  StreamSubscription<Event>? _addServicio;
  StreamSubscription<Event>? _changeService;
  final _servicesRef = FirebaseDatabase.instance
      .reference()
      .child('compras')
      .orderByChild('statusCompra')
      .equalTo('pendiente');
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
                        child: Dismissible(
                          key: Key(_services![position].id!),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (DismissDirection direction) {
                            _setOrder(_services![position]);
                          },
                          background: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              color: MyColors.primaryColorDark,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    Text('Confirmar compra', style: TextStyle(color: Colors.white)),
                              )),
                          child: Row(
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
                                  subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tel. ${_services![position].servicio!.contact}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 18.0,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          'Vendedor: ${_services![position].servicio!.seller}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 18.0,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ]),
                                  leading: Column(
                                    children: [
                                      CircleAvatar(
                                          radius: 25.0,
                                          backgroundImage:
                                              NetworkImage(_services![position].servicio!.img!))
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

  void _borrarService(BuildContext context, Compra game, int position) async {
    await _dbRef.child(game.id!).remove().then((_) {
      setState(() {
        _services!.removeAt(position);
      });
    });
  }

  void _setOrder(Compra compra) async {
    await _dbRef.child(compra.id!).set({
      'servicio': compra.servicio!.toJson(),
      'correoComprador': compra.correoComprador,
      'correoVen': compra.correoVend,
      'statusCompra': 'confirmada',
      'statusVenta': 'pendiente',
      'fechaProbableEntrega': compra.fechaProbableEntrega
    }).then((value) {
      setState(() {
        _services!.removeAt(_services!.indexOf(compra));
      });
    });
  }
}
