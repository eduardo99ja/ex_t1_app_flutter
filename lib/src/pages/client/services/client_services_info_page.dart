import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/pages/seller/services/edit/seller_services_edit_page.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ex_t1_app/src/utils/my_colors.dart' as utils;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientInfoService extends StatefulWidget {
  final Service service;

  ClientInfoService({Key? key, required this.service}) : super(key: key);

  @override
  _ClientInfoServiceState createState() => _ClientInfoServiceState();
}

final serviceRef = FirebaseDatabase.instance.reference().child('compras');

class _ClientInfoServiceState extends State<ClientInfoService> {
  List<Service>? items;
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Informacion del servicio',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: utils.MyColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Card(
              child: Center(
                child: Column(
                  children: [
                    Card(
                      elevation: 3.0,
                      child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Image.network(
                            widget.service.img!,
                            fit: BoxFit.fill,
                          )),
                    ),
                    Text('${widget.service.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            fontSize: 16)),
                    Divider(),
                    Text('Descripción: ${widget.service.description}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            fontSize: 16)),
                    Divider(),
                    Text('Precio: \$${widget.service.price}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            fontSize: 16)),
                    Divider(),
                    Text('Contácto: ${widget.service.contact}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            fontSize: 16)),
                    Divider(),
                    Text('Status: ${widget.service.status}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            fontSize: 16)),
                    Divider(),
                    Container(
                      child: Stack(
                        children: [
                          mapaView(widget.service.lat!, widget.service.lng!),
                          Container(
                            child: Icon(
                              Icons.pin_drop_rounded,
                              size: 40.0,
                              color: utils.MyColors.primaryColorDark,
                            ),
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                      height: 200.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(child: Container()),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        widget.service.status! == 'activo'
                            ? Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    addToCart(widget.service, context);
                                  },
                                  child: Text('Agregar al carro'),
                                ),
                              )
                            : Container()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mapaView(String lat, String lng) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(double.parse(lat), double.parse(lng)), zoom: 16.0),
      mapType: MapType.normal,
    );
  }

  void addToCart(Service service, BuildContext context) async {
    await serviceRef.push().set({
      'servicio': service.toJson(),
      'correoComprador': _authProvider.getUser().email,
      'correoVen': service.contact,
      'statusCompra': 'pendiente',
      'statusVenta': 'pendiente',
      'fechaProbableEntrega': 'pendiente'
    }).then((_) => Navigator.pop(context));
  }
}
