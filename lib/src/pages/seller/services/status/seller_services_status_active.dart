import 'dart:async';

import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SellerServicesStatusActive extends StatefulWidget {
  const SellerServicesStatusActive({Key? key}) : super(key: key);

  @override
  _SellerServicesStatusActiveState createState() =>
      _SellerServicesStatusActiveState();
}

class _SellerServicesStatusActiveState
    extends State<SellerServicesStatusActive> {
  List<Service>? _services;
  StreamSubscription<Event>? _addServicio;
  StreamSubscription<Event>? _changeService;
  final _servicesRef = FirebaseDatabase.instance
      .reference()
      .child('services')
      .orderByChild('status')
      .equalTo('activo');
  final _dbRef = FirebaseDatabase.instance.reference().child('services');

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
                          direction: DismissDirection.horizontal,
                          onDismissed: (DismissDirection direction) {
                            print(direction);
                            if (direction == DismissDirection.endToStart) {
                              _setInactive(_services![position]);
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              _borrarService(
                                  context, _services![position], position);
                            }
                          },
                          secondaryBackground: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Marcar como inactivo',
                                    style: TextStyle(color: Colors.white)),
                              )),
                          background: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              color: Colors.red,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Eliminar servicio',
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

  void _updateServices(Event event) {
    var oldService =
        _services!.singleWhere((service) => service.id == event.snapshot.key);
    setState(() {
      _services?[_services!.indexOf(oldService)] =
          Service.fromSnapShot(event.snapshot);
    });
  }

  void _borrarService(BuildContext context, Service game, int position) async {
    await _dbRef.child(game.id!).remove().then((_) {
      setState(() {
        _services!.removeAt(position);
      });
    });
  }

  void _setInactive(Service servicio) {
    _dbRef.child(servicio.id!).set({
      'name': servicio.name,
      'lat': servicio.lat,
      'lng': servicio.lng,
      'seller': servicio.seller,
      'img': servicio.img,
      'contact': servicio.contact,
      'price': servicio.price,
      'description': servicio.description,
      'status': 'inactivo'
    }).then((value) {
      setState(() {
        _services!.removeAt(_services!.indexOf(servicio));
      });
    });
  }
}
