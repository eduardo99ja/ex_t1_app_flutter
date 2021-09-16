import 'package:flutter/material.dart';

import 'package:ex_t1_app/src/models/user.dart';

import 'package:ex_t1_app/src/utils/shared_pref.dart';

class SellerHomeController {
  late BuildContext context;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late Function refresh;
  User? user;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

    getCategories();
    refresh();
  }

  void getCategories() async {
    refresh();
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToUpdatePage() {
    Navigator.pushNamed(context, 'seller/update');
  }

  void goToCreate() {
    Navigator.pushNamed(context, 'seller/services/create');
  }

  void goToList() {
    Navigator.pushNamed(context, 'seller/services/list');
  }

  void goToCredits() {
    Navigator.pushNamed(context, 'credits');
  }

  void goToSearch() {
    Navigator.pushNamed(context, 'seller/services/search');
  }
}
