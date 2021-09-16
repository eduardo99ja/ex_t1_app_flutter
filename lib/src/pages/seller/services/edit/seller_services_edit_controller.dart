import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ex_t1_app/src/models/service.dart';
import 'package:ex_t1_app/src/models/user.dart';
import 'package:ex_t1_app/src/providers/storage_provider.dart';
import 'package:ex_t1_app/src/utils/shared_pref.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as location;
import 'package:ndialog/ndialog.dart';

class SellerServicesEditController {
  late BuildContext context;
  late Function refresh;
  List<Service> items = [];
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController contactController = new TextEditingController();
  TextEditingController latController = new TextEditingController();
  TextEditingController lngController = new TextEditingController();
  TextEditingController imgController = new TextEditingController();
  TextEditingController priceController = new TextEditingController(text: '0');

  User? user;
  SharedPref sharedPref = new SharedPref();
  PickedFile? pickedFile;
  Position? _position;
  late final serviceRef;
  late StorageProvider _storageProvider;
  late Service service;

  File? imageFile1;

  late ProgressDialog _progressDialog;
  CameraPosition initialPosition =
      CameraPosition(target: LatLng(-99.5316192, -99.5316192), zoom: 16.0);
  Completer<GoogleMapController> _mapController = Completer();

  Future init(BuildContext context, Function refresh, Service service) async {
    this.context = context;
    this.refresh = refresh;
    this.service = service;
    serviceRef = FirebaseDatabase.instance.reference().child('services');
    _storageProvider = new StorageProvider();
    nameController.text = service.name!;
    descriptionController.text = service.description!;
    contactController.text = service.contact!;
    priceController.text = service.price!;
    checkGPS();
    _progressDialog = new ProgressDialog(context,
        title: Text('Expere....'), message: Text('Cargando...'));
    user = User.fromJson(await sharedPref.read('user'));
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      if (numberFile == 1) {
        imageFile1 = File(pickedFile!.path);
      }
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('GALERIA'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
        },
        child: Text('CAMARA'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  void updateLocation() async {
    try {
      await _determinePosition(); // OBTENER LA POSICION ACTUAL Y TAMBIEN SOLICITAR LOS PERMISOS
      _position = await Geolocator.getLastKnownPosition(); // LAT Y LNG
      animateCameraToPosition(_position!.latitude, _position!.longitude);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 16, bearing: 0)));
    }
  }

  void editService() async {
    print('entro');
    String? imageUrl;

    String name = nameController.text;
    String description = descriptionController.text;
    String contact = contactController.text;
    String price = priceController.text;

    if (name.isEmpty ||
        description.isEmpty ||
        contact.isEmpty ||
        price.isEmpty) {
      final snackBar =
          SnackBar(content: Text('Debes ingresar todos los campos'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    _progressDialog.show();
    if (pickedFile != null) {
      TaskSnapshot snapshot = await _storageProvider.uploadFile(pickedFile!);
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    Service _service = Service(
        contact: contactController.text,
        name: nameController.text,
        description: descriptionController.text,
        lat: _position!.latitude.toString(),
        lng: _position!.longitude.toString(),
        img: imageUrl != null ? imageUrl : service.img,
        price: priceController.text,
        seller: user!.email,
        status: service.status);

    await serviceRef
        .child(service.id)
        .set(_service.toJson())
        .then((_) => {Navigator.pop(context)});
    _progressDialog.dismiss();
  }
}
