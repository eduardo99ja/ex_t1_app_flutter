import 'package:flutter/material.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:ex_t1_app/src/utils/shared_pref.dart';

class RolesController {
  late BuildContext context;
  late SharedPref _sharedPref;

  late AuthProvider _authProvider;
  String? _typeUser;

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();

    _typeUser = await _sharedPref.read('typeUser');

    checkIfUserIsAuth();
  }

  void checkIfUserIsAuth() {
    bool isSigned = _authProvider.isSignedIn();
    if (isSigned) {
      print('ya esta');
      if (_typeUser == 'client') {
        print('ya esta');
        // Navigator.pushNamedAndRemoveUntil(
        //     context, 'client/home', (route) => false);
        // Navigator.pushNamed(context, 'client/map');
      } else {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, 'seller/home', (route) => false);
        // Navigator.pushNamed(context, 'driver/map');
      }
    } else {
      print('NO ESTA LOGEADO');
    }
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) {
    _sharedPref.save('typeUser', typeUser);
  }
}
