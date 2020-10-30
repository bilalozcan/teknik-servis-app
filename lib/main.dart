import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/MainPage.dart';
import 'ui/SignInPage.dart';

SharedPreferences prefs;

void main() {
  runApp(new MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.black,
          focusColor: Colors.black,
          textSelectionColor: Colors.black,
          accentColor: Colors.black,
          unselectedWidgetColor: Colors.black,
          indicatorColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: SignInPage()
  ));
}



