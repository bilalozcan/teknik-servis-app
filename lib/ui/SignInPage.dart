import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'MainPage.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _username, _password, initialValue = "";
  bool _obsecure = true;
  Icon _obsecureIcon = Icon(
    Icons.visibility,
    color: Colors.white,
  );
  final formKey = GlobalKey<FormState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    _prefs.then((SharedPreferences prefs) => null);
    checkUser();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void checkUser() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getString("username") == "bilalozcan" &&
        prefs.getString("password") == "123456") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

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
                  ),
                ),
                validator: (girilen) => null,
                initialValue: initialValue,
                onSaved: (value) => _username = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.white,
                obscureText: _obsecure,
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
                    suffixIcon: GestureDetector(
                        child: _obsecureIcon, onTap: _obsecureChange),
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

  void _SignIn(BuildContext context) async {
    String username = "bilalozcan";
    String password = "123456";
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      debugPrint("Username: $_username, Password: $_password");
      if (_username != username || _password != password) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            initialValue = "";
                          });
                        },
                        child: Text("Tamam"))
                  ],
                  backgroundColor: Colors.red,
                  content: Text("Kullanıcı adı veya şifre yanlış!"),
                ));
      } else {
        _saveLoginInformation();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    }
  }

  Future<void> _saveLoginInformation() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("username", _username);
    prefs.setString("password", _password);
  }

  void _obsecureChange() {
    setState(() {
      if (_obsecure) {
        _obsecureIcon = Icon(
          Icons.visibility_off,
          color: Colors.white,
        );
        _obsecure = false;
      } else {
        _obsecureIcon = Icon(
          Icons.visibility,
          color: Colors.white,
        );
        _obsecure = true;
      }
    });
  }
}
