import 'package:ex_t1_app/src/models/compra.dart';
import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/pages/seller/services/edit/seller_services_edit_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ex_t1_app/src/utils/my_colors.dart' as utils;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoServiceOrder extends StatefulWidget {
  final Compra service;

  InfoServiceOrder({Key? key, required this.service}) : super(key: key);

  @override
  _InfoServiceOrderState createState() => _InfoServiceOrderState();
}

final serviceRef = FirebaseDatabase.instance.reference().child('compras');

class _InfoServiceOrderState extends State<InfoServiceOrder> {
  List<Compra>? items;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Informacion de la compra'),
        backgroundColor: utils.MyColors.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
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
                          widget.service.servicio!.img!,
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text('${widget.service.servicio!.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Descripción: ${widget.service.servicio!.description}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Precio: \$${widget.service.servicio!.price}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Cliente: ${widget.service.correoComprador}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Entrega: ${widget.service.fechaProbableEntrega}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Container(
                    child: Stack(
                      children: [
                        mapaView(widget.service.servicio!.lat!, widget.service.servicio!.lng!),
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
                    ],
                  )
                ],
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
}
