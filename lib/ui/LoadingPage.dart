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
    if (prefs.getString("username") == "bilalozcan" &&
        prefs.getString("password") == "123456") {
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
            ),
            Container(
                width: 230,
                height: 230,
                child: Image.asset(
                  "assets/images/TeknikServis.png",
                )),
            Image.asset("assets/images/loading2.gif")
          ],
        ),
      ),
    );
  }
}
