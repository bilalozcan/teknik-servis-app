import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

import 'MainPage.dart';

class SignInPage extends StatelessWidget {
  String _username, _password;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Form(
        key: formKey,
        autovalidate: true,
        child: ListView(
          children: [
            Icon(
              Icons.account_circle,
              size: 250,
              color: Colors.red.shade700,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusColor: Colors.amber,
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.white,
                    ),
                    hintText: "Kullanıcı Adını Giriniz",
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "Kullanıcı Adı",
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      color: Colors.white,
                    )),
                validator: (girilen) => null,
                onSaved: (value) => _username = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.white,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    hintText: "Şifreyi Giriniz",
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "Şifre",
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      color: Colors.white,
                    )),
                validator: (girilen) => null,
                onSaved: (value) => _password = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 100, right: 100, top: 20),
              child: RaisedButton(
                child: Text("Giriş Yap"),
                onPressed: () {
                  _SignIn(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _SignIn(BuildContext context) {
    String username = "bilalozcan";
    String password = "123456";
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      debugPrint("Username: $_username, Password: $_password");
      if (_username != username && _password != password) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.red,
              content: Text("Kullanıcı adı veya şifre yanlış!"),
            ));

      }else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    }
  }
}
