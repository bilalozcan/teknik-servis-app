import "package:flutter/material.dart";

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Form(
        child: ListView(
          children: [
            Icon(
              Icons.account_circle,
              size: 250,
              color: Colors.grey.shade500,
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
              ),
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
              ),
            ),
            RaisedButton(
              child: Text("Giriş Yap"),
              onPressed: () {},
              padding: EdgeInsets.all(8.0),
            )
          ],
        ),
      ),
    );
  }
}
