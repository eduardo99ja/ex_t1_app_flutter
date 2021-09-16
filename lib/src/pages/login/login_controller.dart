import 'package:ex_t1_app/src/models/user.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:ex_t1_app/src/utils/shared_pref.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:ndialog/ndialog.dart';

class LoginController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  late AuthProvider _authProvider;
  late SharedPref _sharedPref;
  late final userRef;
  String? _typeUser;

  Future init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _sharedPref = new SharedPref();
    userRef = FirebaseDatabase.instance.reference();
    _typeUser = await _sharedPref.read('typeUser');
    print(_typeUser);
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    ProgressDialog _progressDialog = ProgressDialog(context,
        message: Text("Por favor, espere un momento"), title: Text("Cargando"));
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      final snackBar = SnackBar(content: Text('Debes ingresar sus credenciales'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    _progressDialog.show();

    try {
      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.dismiss();

      if (isLogin) {
        if (_typeUser == 'seller') {
          bool flag = false;
          Query _compradorQuery =
              userRef.child('vendedores').orderByChild("email").equalTo(emailController.text);

          _compradorQuery.get().then((value) {
            Map<dynamic, dynamic> map = value.value;
            map.forEach((key, value) {
              if (emailController.text == value['email']) {
                flag = true;
                User user = User(
                    email: value['email'],
                    username: value['username'],
                    name: value['name'],
                    lastname: value['lastname'],
                    id: _authProvider.getUser().uid);
                _sharedPref.save('user', user.toJson());

                Navigator.pushNamedAndRemoveUntil(context, 'seller/home', (route) => false);
              }
            });

            if (!flag) {
              final snackBar =
                  SnackBar(content: Text('El usuario no se encuentra registrado como vendedor'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        } else if (_typeUser == 'client') {
          bool flag = false;
          Query _compradorQuery =
              userRef.child('clientes').orderByChild("email").equalTo(emailController.text);

          _compradorQuery.get().then((value) {
            Map<dynamic, dynamic> map = value.value;
            map.forEach((key, value) {
              if (emailController.text == value['email']) {
                flag = true;
                print(value);
                User user = User(
                    email: value['email'],
                    username: value['username'],
                    name: value['name'],
                    lastname: value['lastname'],
                    id: _authProvider.getUser().uid);
                _sharedPref.save('user', user.toJson());
                Navigator.pushNamedAndRemoveUntil(context, 'client/home', (route) => false);
              }
            });
            if (!flag) {
              final snackBar =
                  SnackBar(content: Text('El usuario no se encuentra registrado como cliente'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        }
        print('El usuario esta logeado');
      }
    } catch (error) {
      _progressDialog.dismiss();
      final snackBar = SnackBar(content: Text('Error: $error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
