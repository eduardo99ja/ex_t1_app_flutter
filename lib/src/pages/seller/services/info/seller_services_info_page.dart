import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/pages/seller/services/edit/seller_services_edit_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ex_t1_app/src/utils/my_colors.dart' as utils;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoService extends StatefulWidget {
  final Service service;

  InfoService({Key? key, required this.service}) : super(key: key);

  @override
  _InfoServiceState createState() => _InfoServiceState();
}

final serviceRef = FirebaseDatabase.instance.reference().child('services');

class _InfoServiceState extends State<InfoService> {
  List<Service>? items;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Informacion del servicio'),
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
                          widget.service.img!,
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text('${widget.service.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Descripción: ${widget.service.description}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Precio: \$${widget.service.price}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Contácto: ${widget.service.contact}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
                  Divider(),
                  Text('Status: ${widget.service.status}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 16)),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SellerServicesEditPage(service: widget.service),
                                    ),
                                  );
                                },
                                child: Text('Editar'),
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
