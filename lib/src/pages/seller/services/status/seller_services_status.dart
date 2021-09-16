import 'package:ex_t1_app/src/pages/seller/services/status/seller_services_status_active.dart';
import 'package:ex_t1_app/src/pages/seller/services/status/seller_services_status_inactive.dart';
import 'package:flutter/material.dart';

class SellerServicesStatus extends StatelessWidget {
  const SellerServicesStatus({Key? key}) : super(key: key);

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
              text: 'Activos',
            ),
            Tab(
              icon: Icon(Icons.offline_bolt),
              text: 'Inactivos',
            )
          ]),
        ),
        body: TabBarView(
          children: [
            SellerServicesStatusActive(),
            SellerServicesStatusInactive()
          ],
        ),
      ),
    );
  }
}
