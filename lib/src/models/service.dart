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
  String? seller;
  String? status;

  Service(
      {this.id,
      this.name,
      this.description,
      this.contact,
      this.lat,
      this.lng,
      this.img,
      this.price,
      this.seller,
      this.status});

  Service.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.description = obj['description'];
    this.contact = obj['contact'];
    this.lat = obj['lat'];
    this.lng = obj['lng'];
    this.img = obj['img'];
    this.price = obj['price'];
    this.seller = obj['seller'];
    this.status = obj['status'];
  }

  Service.fromSnapShot(DataSnapshot snapShot) {
    id = snapShot.key;
    name = snapShot.value['name'];
    description = snapShot.value['description'];
    contact = snapShot.value['contact'];
    lat = snapShot.value['lat'];
    lng = snapShot.value['lng'];
    img = snapShot.value['img'];
    price = snapShot.value['price'];
    seller = snapShot.value['seller'];
    status = snapShot.value['status'];
  }
  Map<String, dynamic> toJson() => {
        'contact': contact,
        'name': name,
        'description': description,
        'lat': lat,
        'lng': lng,
        'img': img,
        'price': price,
        'seller': seller,
        'status': status
      };
}
