import 'dart:async';

import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/pages/client/services/client_services_info_page.dart';
import 'package:ex_t1_app/src/pages/seller/services/edit/seller_services_edit_page.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ClientServicesListPage extends StatefulWidget {
  const ClientServicesListPage({Key? key}) : super(key: key);

  @override
  _ClientServicesListPageState createState() => _ClientServicesListPageState();
}

class _ClientServicesListPageState extends State<ClientServicesListPage> {
  bool searchState = false;
  List<Service>? _services;
  StreamSubscription<Event>? _addServicio;
  StreamSubscription<Event>? _changeService;
  final _dbRef = FirebaseDatabase.instance
      .reference()
      .child('services')
      .orderByChild('status')
      .equalTo('activo');
  @override
  void initState() {
    super.initState();
    _addServicio = _dbRef.onChildAdded.listen(_agregarService);
    _changeService = _dbRef.onChildChanged.listen(_updateServices);
    _services = [];
  }

  @override
  void dispose() {
    super.dispose();
    _addServicio!.cancel();
    _changeService!.cancel();
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
        child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7),
            itemCount: _services?.length ?? 0,
            itemBuilder: (_, index) {
              return _cardService(_services![index], index);
            }),
      ),
    );
  }

  Widget _cardService(Service service, int index) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: false,
            context: context,
            builder: (context) =>
                ClientInfoService(service: _services![index])); //Using anonimous function
      },
      child: Container(
        height: 250,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                  top: -1.0,
                  right: -1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(20),
                        )),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.all(20),
                    child: FadeInImage(
                      image: service.img != null
                          ? NetworkImage(service.img!)
                          : AssetImage('assets/img/pizza2.png') as ImageProvider,
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 33,
                    child: Text(
                      service.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, fontFamily: 'NimbusSans'),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      '\$${service.price ?? 0}',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'NimbusSans'),
                    ),
                  )
                ],
              )
            ],
          ),
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

  void infoService(BuildContext context, Service service) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SellerServicesEditPage(service: service),
      ),
    );
  }

  void _updateServices(Event event) {
    var oldService = _services!.singleWhere((service) => service.id == event.snapshot.key);
    setState(() {
      _services?[_services!.indexOf(oldService)] = Service.fromSnapShot(event.snapshot);
    });
  }
}
