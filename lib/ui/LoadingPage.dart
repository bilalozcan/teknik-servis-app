import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainPage.dart';
import 'SignInPage.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) => null);
    checkUser();
  }

  void checkUser() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getString("username") == "teknikservis" &&
        prefs.getString("password") == "!teknik-051") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        color: Colors.grey.shade900,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Teknik Servis App",
              style: TextStyle(color: Colors.white, fontSize: 50),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                  value: 40,
                  valueColor: AlwaysStoppedAnimation(Colors.red)),
              height: 25,
              width: 25,
            )
          ],
        ),
      ),
    );
  }
}
