import 'package:ex_t1_app/src/pages/client/services/cart/client_services_cart_tab.dart';
import 'package:ex_t1_app/src/pages/client/services/cart/client_services_orders_tab.dart';
import 'package:flutter/material.dart';

class ClientServicesCartPage extends StatelessWidget {
  const ClientServicesCartPage({Key? key}) : super(key: key);

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
              text: 'Carrito',
            ),
            Tab(
              icon: Icon(Icons.offline_bolt),
              text: 'Compras',
            )
          ]),
        ),
        body: TabBarView(
          children: [ClientServicesCartTab(), ClientServicesOrdersTab()],
        ),
      ),
    );
  }
}
