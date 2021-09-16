import 'dart:async';

import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SellerServicesSearchPage extends StatefulWidget {
  const SellerServicesSearchPage({Key? key}) : super(key: key);

  @override
  _SellerServicesSearchPageState createState() =>
      _SellerServicesSearchPageState();
}

class _SellerServicesSearchPageState extends State<SellerServicesSearchPage> {
  bool searchState = false;
  List<Service>? _services;
  StreamSubscription<Event>? _addServicio;
  final _dbRef = FirebaseDatabase.instance.reference().child('services');
  @override
  void initState() {
    super.initState();
    _addServicio = _dbRef.onChildAdded.listen(_agregarService);
    _services = [];
  }

  @override
  void dispose() {
    super.dispose();
    _addServicio!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !searchState
            ? Text(
                'Servicios',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white),
                    hintText: 'Buscar...',
                    hintStyle: TextStyle(color: Colors.white)),
                onChanged: (text) {
                  print('entro busqueda');
                  searchMethod(text);
                },
              ),
        actions: [
          !searchState
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  },
                ),
        ],
      ),
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
                        // onTap: () {
                        //   showModalBottomSheet(
                        //       isScrollControlled: true,
                        //       context: context,
                        //       builder: (context) => InfoService(
                        //           service: _services![
                        //               position])); //Using anonimous function
                        // },
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
              ],
            );
          },
        ),
      ),
    );
  }

  void searchMethod(String text) {
    _dbRef.get().then((DataSnapshot snapShot) {
      print(snapShot);
      _services!.clear();
      var keys = snapShot.value.keys;
      var values = snapShot.value;
      for (var key in keys) {
        Service service = Service(
          id: key,
          name: values[key]['name'],
          description: values[key]['description'],
          contact: values[key]['contact'],
          img: values[key]['img'],
          lat: values[key]['lat'],
          lng: values[key]['name'],
          price: values[key]['name'],
          seller: values[key]['seller'],
          status: values[key]['status'],
        );
        if (service.name!.contains(text)) {
          _services!.add(service);
        }
        setState(() {});
      }
    });
  }

  void _agregarService(Event event) {
    setState(() {
      _services!.add(Service.fromSnapShot(event.snapshot));
    });
  }
}
