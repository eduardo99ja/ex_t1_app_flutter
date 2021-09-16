import 'dart:async';

import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SellerServicesStatusInactive extends StatefulWidget {
  const SellerServicesStatusInactive({Key? key}) : super(key: key);

  @override
  _SellerServicesStatusInactiveState createState() =>
      _SellerServicesStatusInactiveState();
}

class _SellerServicesStatusInactiveState
    extends State<SellerServicesStatusInactive> {
  List<Service>? _services;
  StreamSubscription<Event>? _addServicio;
  final _servicesRef = FirebaseDatabase.instance
      .reference()
      .child('services')
      .orderByChild('status')
      .equalTo('inactivo');
  final _dbRef = FirebaseDatabase.instance.reference().child('services');
  // AuthProvider

  @override
  void initState() {
    super.initState();
    _services = [];
    _addServicio = _servicesRef.onChildAdded.listen(_agregarService);
  }

  @override
  void dispose() {
    super.dispose();
    _addServicio!.cancel();
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
                          direction: DismissDirection.horizontal,
                          onDismissed: (DismissDirection direction) {
                            print(direction);
                            if (direction == DismissDirection.endToStart) {
                              _setActive(_services![position]);
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              _borrarService(
                                  context, _services![position], position);
                            }
                          },
                          secondaryBackground: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              color: Colors.blueAccent,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Marcar como activo',
                                    style: TextStyle(color: Colors.white)),
                              )),
                          background: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Eliminar completamente',
                                    style: TextStyle(color: Colors.white)),
                              )),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    '${_services![position].name}',
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_services![position].description}',
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
                                  onTap: () {
                                    // TODO: Ver detalles
                                    // showModalBottomSheet(
                                    //     context: context,
                                    //     builder: (context) => InfoGame(
                                    //         game: _services![
                                    //             position])); //Using anonimous function
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  '\$${_services![position].price}',
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
      _services!.add(Service.fromSnapShot(event.snapshot));
    });
  }

  void _borrarService(BuildContext context, Service game, int position) async {
    await _dbRef.child(game.id!).remove().then((_) {
      setState(() {
        _services!.removeAt(position);
      });
    });
  }

  void _setActive(Service servicio) {
    _dbRef.child(servicio.id!).set({
      'name': servicio.name,
      'lat': servicio.lat,
      'lng': servicio.lng,
      'seller': servicio.seller,
      'img': servicio.img,
      'contact': servicio.contact,
      'price': servicio.price,
      'description': servicio.description,
      'status': 'activo'
    }).then((value) {
      setState(() {
        _services!.removeAt(_services!.indexOf(servicio));
      });
    });
  }
}
