import 'package:flutter/material.dart';
import 'package:ex_t1_app/src/models/user.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:ndialog/ndialog.dart';

class RegisterController {
  late BuildContext context;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  late AuthProvider _authProvider;
  late ProgressDialog progressDialog;

  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = new AuthProvider();
    progressDialog = ProgressDialog(context,
        message: Text("Por favor, espere un momento"), title: Text("Cargando"));
  }

  void register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      final snackBar =
          SnackBar(content: Text('Debes ingresar todos los campos'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    if (confirmPassword != password) {
      final snackBar = SnackBar(content: Text('Las contraseñas no coinciden'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (password.length < 6) {
      print('el password debe tener al menos 6 caracteres');
      final snackBar = SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    progressDialog.show();

    try {
      bool isRegister = await _authProvider.register(email, password);

      if (isRegister) {
        progressDialog.dismiss();
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      } else {
        progressDialog.dismiss();

        final snackBar =
            SnackBar(content: Text('El usuario no se pudó registrar'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      progressDialog.dismiss();

      final snackBar = SnackBar(content: Text('Error: $error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
