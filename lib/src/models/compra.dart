import 'package:ex_t1_app/src/models/service.dart';
import 'package:firebase_database/firebase_database.dart';

class Compra {
  String? id;
  String? correoComprador;
  Service? servicio;
  String? statusCompra;
  String? statusVenta;
  String? correoVend;
  String? fechaProbableEntrega;

  Compra(this.id, this.correoComprador, this.servicio, this.statusCompra, this.statusVenta,
      this.correoVend, this.fechaProbableEntrega);

  Compra.map(dynamic obj) {
    this.id = obj['id'];
    this.correoVend = obj['correoVend'];
    this.correoComprador = obj['correoComprador'];
    this.servicio = obj['servicio'];
    this.statusCompra = obj['statusCompra'];
    this.statusVenta = obj['statusVenta'];
    this.fechaProbableEntrega = obj['fechaProbableEntrega'];
  }

  Compra.fromSnapshot(DataSnapshot snapShot) {
    id = snapShot.key;
    correoComprador = snapShot.value['correoComprador'];
    correoVend = snapShot.value['correoVend'];
    servicio = snapShot.value['servicio'];
    statusCompra = snapShot.value['statusCompra'];
    statusVenta = snapShot.value['statusVenta'];
    fechaProbableEntrega = snapShot.value['fechaProbableEntrega'];
  }
}
