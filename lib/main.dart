import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teknik_servis/ui/LoadingPage.dart';
import 'ui/MainPage.dart';
import 'ui/SignInPage.dart';

SharedPreferences prefs;

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.grey.shade800,
      focusColor: Colors.grey.shade800,
      appBarTheme: AppBarTheme(
        color: Colors.grey.shade800,
      ),
      textSelectionColor: Colors.grey.shade800,
      accentColor: Colors.grey.shade800,
      unselectedWidgetColor: Colors.white,
      indicatorColor: Colors.grey.shade800,
    ),
    debugShowCheckedModeBanner: false,
    home: LoadingPage(),
  ));
}
