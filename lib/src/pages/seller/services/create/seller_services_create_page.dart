import 'dart:io';

import 'package:ex_t1_app/src/pages/seller/services/create/seller_services_create_controller.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SellerServicesCreatePage extends StatefulWidget {
  const SellerServicesCreatePage({Key? key}) : super(key: key);

  @override
  _SellerServicesCreatePageState createState() =>
      _SellerServicesCreatePageState();
}

class _SellerServicesCreatePageState extends State<SellerServicesCreatePage> {
  SellerServicesCreateController _con = SellerServicesCreateController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Nuevo servicio',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          _cardImage(_con.imageFile1, 1),
          _textFieldName(),
          _textFieldDescription(),
          _textFieldContact(),
          _textFieldPrice(),
          Container(
            height: 250.0,
            child: Stack(
              children: [
                _googleMaps(),
                Container(
                  alignment: Alignment.center,
                  child: _iconMyLocation(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _iconMyLocation() {
    return Image.asset(
      'assets/img/my_location.png',
      width: 60,
      height: 60,
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        _con.initialPosition = position;
      },
    );
  }

  Widget _textFieldName() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nameController,
        maxLines: 1,
        maxLength: 180,
        decoration: InputDecoration(
            hintText: 'Nombre del servicio',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            suffixIcon: Icon(
              Icons.local_pizza,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldContact() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.contactController,
        maxLines: 1,
        maxLength: 180,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Numero de contacto',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            suffixIcon: Icon(
              Icons.local_pizza,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
          hintText: 'Descripcion del servicio',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          suffixIcon: Icon(
            Icons.description,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldPrice() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.priceController,
        keyboardType: TextInputType.number,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: 'Precio',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            suffixIcon: Icon(
              Icons.monetization_on,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _cardImage(File? imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {
        _con.showAlertDialog(numberFile);
      },
      child: imageFile != null
          ? Card(
              elevation: 3.0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              elevation: 3.0,
              child: Container(
                height: 140,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image(
                  image: AssetImage('assets/img/add_image.png'),
                ),
              ),
            ),
    );
  }

  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('CREAR DIRECCION'),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: MyColors.primaryColor),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
