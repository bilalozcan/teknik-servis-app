import 'package:flutter/material.dart';
import 'package:teknik_servis/model/Document.dart';
import 'package:teknik_servis/utils/DatabaseHelper.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DatabaseHelper db1;
  List<Document> tumDokumanListesi;
  final formKey = GlobalKey<FormState>();
  String currentvalue = null;
  String _marka,
      _servisAdi,
      _servisTel,
      _teknisyenAdi,
      _tarih,
      _musteriAd,
      _musteriTel,
      _musteriAdres,
      _cihazSeriNo,
      _cihazModel,
      _cihazTip,
      _parcalar,
      _yapilanBakim,
      _yapilanIs,
      _aciklama,
      _ucret;
  bool chechBoxValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDokumanListesi = List<Document>();
    db1 = DatabaseHelper();
    //Yerel Veritabanından veri çekme işlemi
    db1.allDocument().then((allDocumentMapList) {
      for (Map docMap in allDocumentMapList) {
        tumDokumanListesi.add(Document.fromMap(docMap));
      }
    });
    for(Document docMap in tumDokumanListesi){
      debugPrint(docMap.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("SM Teknik Servis"),
        leading: Icon(Icons.print),
        actions: [
          Icon(
            Icons.history,
            size: 36,
          )
        ],
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Container(
              color: Colors.grey.shade800,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: DropdownButton<String>(
                          iconEnabledColor: Colors.pink,
                          dropdownColor: Colors.pink,
                          iconDisabledColor: Colors.blue,
                          focusColor: Colors.green,
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              decorationColor: Colors.amber),
                          items: [
                            DropdownMenuItem<String>(
                                child: Text("Vaillant"), value: "Vaillant"),
                            DropdownMenuItem<String>(
                                child: Text("DemirDöküm"), value: "Demirdöküm"),
                            DropdownMenuItem<String>(
                                child: Text("ECA"), value: "ECA"),
                            DropdownMenuItem<String>(
                                child: Text("Baymak"), value: "Baymak"),
                            DropdownMenuItem<String>(
                                child: Text("Protherm"), value: "Protherm"),
                            DropdownMenuItem<String>(
                                child: Text("Buderus"), value: "Buderus"),
                            DropdownMenuItem<String>(
                                child: Text("Viessman"), value: "Viessman"),
                            DropdownMenuItem<String>(
                                child: Text("Bosch"), value: "Bosch"),
                            DropdownMenuItem<String>(
                                child: Text("Ferroli"), value: "Ferroli"),
                            DropdownMenuItem<String>(
                                child: Text("Ariston"), value: "Ariston"),
                            DropdownMenuItem<String>(
                                child: Text("Alarko"), value: "Alarko"),
                            DropdownMenuItem<String>(
                                child: Text("Airfel"), value: "Airfel"),
                            DropdownMenuItem<String>(
                                child: Text("Arçelik"), value: "Arçelik"),
                            DropdownMenuItem<String>(
                                child: Text("Beko"), value: "Beko"),
                            DropdownMenuItem<String>(
                                child: Text("Baykan"), value: "Baykan"),
                          ],
                          onChanged: (String secilen) {
                            _marka = secilen;
                            setState(() {
                              currentvalue = secilen;
                            });
                          },
                          hint: Text("Marka Seçin"),
                          value: currentvalue,
                        ),
                      ),
                      Container(
                        width: 250,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.visiblePassword,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    labelText: "Servis Adı",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    )),
                                validator: (girilen) => null,
                                onSaved: (value) => _servisAdi = value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.visiblePassword,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintStyle: TextStyle(color: Colors.white),
                                    labelText: "Servis Telefon Numarası",
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    )),
                                validator: (girilen) => null,
                                onSaved: (value) => _servisTel = value,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Teknisyen Adı",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _teknisyenAdi = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Tarih",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _tarih = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Müşteri Ad Soyad",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _musteriAd = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Müşteri Telefon Numarası",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _musteriTel = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Müşteri Adres",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _musteriAdres = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Cihaz Seri No",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _cihazSeriNo = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Cihaz Model",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _cihazModel = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Cihaz Tipi",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _cihazTip = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Kullanılan Parçalar",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _parcalar = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Yapılan Bakım",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _yapilanBakim = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Yapılan İşçilik",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _yapilanIs = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Açıklama",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _aciklama = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: "Ücret",
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      validator: (girilen) => null,
                      onSaved: (value) => _ucret = value,
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.fromLTRB(150, 4, 150, 0),
                    isThreeLine: false,
                    value: chechBoxValue,
                    onChanged: (secildi) {
                      setState(() {
                        chechBoxValue = secildi;
                      });
                    },
                    title: Text(
                      "Garanti",
                      style: TextStyle(color: Colors.white),
                    ),
                    checkColor: Colors.white,
                  ),
                  RaisedButton(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        width: 250,
                        height: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [Icon(Icons.print), Icon(Icons.save)],
                        ),
                      ),
                      onPressed: () {
                        _Kaydet();
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _Kaydet() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      var doc = Document(
          _marka,
          _servisAdi,
          _servisTel,
          _teknisyenAdi,
          _tarih,
          _musteriAd,
          _musteriTel,
          _musteriAdres,
          _cihazSeriNo,
          _cihazModel,
          _cihazTip,
          _parcalar,
          _yapilanBakim,
          _yapilanIs,
          _aciklama,
          _ucret,
          chechBoxValue.toString());
      debugPrint(" doc.string:" + doc.toString());
      db1.addDocument(doc);

      /*debugPrint("SaveButton List len: " + tumDokumanListesi.length.toString());
      for(Document docMap in tumDokumanListesi){
        debugPrint("docMap.toString"+ docMap.toString());
      }*/
    }
  }
}