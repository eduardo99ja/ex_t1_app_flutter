import 'package:firebase_database/firebase_database.dart';

class Service {
  String? id;
  String? name;
  String? description;
  String? contact;
  String? lat;
  String? lng;
  String? img;
  String? price;

  Service(
      {this.id,
      this.name,
      this.description,
      this.contact,
      this.lat,
      this.lng,
      this.img,
      this.price});

  Service.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.description = obj['description'];
    this.contact = obj['contact'];
    this.lat = obj['lat'];
    this.lng = obj['lng'];
    this.img = obj['img'];
    this.price = obj['price'];
  }

  Service.fromSnapshot(DataSnapshot snapShot) {
    id = snapShot.key;
    name = snapShot.value['name'];
    description = snapShot.value['description'];
    contact = snapShot.value['contact'];
    lat = snapShot.value['lat'];
    lng = snapShot.value['lng'];
    img = snapShot.value['img'];
    price = snapShot.value['price'];
  }
}
