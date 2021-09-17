import 'package:ex_t1_app/src/pages/client/services/cart/client_services_cart_tab.dart';
import 'package:ex_t1_app/src/pages/client/services/cart/client_services_orders_tab.dart';
import 'package:ex_t1_app/src/pages/seller/orders/seller_orders_confirmed_tab.dart';
import 'package:ex_t1_app/src/pages/seller/orders/seller_orders_pending_tab.dart';
import 'package:flutter/material.dart';

class SellerOrdersPage extends StatelessWidget {
  const SellerOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.lock_clock),
              text: 'Ventas pendientes',
            ),
            Tab(
              icon: Icon(Icons.offline_bolt),
              text: 'Ventas completadas',
            )
          ]),
        ),
        body: TabBarView(
          children: [SellerOrdersPendingTab(), SellerOrdersConfirmedTab()],
        ),
      ),
    );
  }
}
