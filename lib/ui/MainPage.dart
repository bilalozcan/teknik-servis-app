import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:teknik_servis/model/Document.dart';
import 'package:teknik_servis/ui/SelectPrinterPage.dart';
import 'package:teknik_servis/utils/DatabaseHelper.dart';
import 'package:toast/toast.dart';
import 'HistoryDocumentsPage.dart';
import 'package:date_format/date_format.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DatabaseHelper _databaseHelper;
  List<Document> tumDokumanListesi;
  final formKey = GlobalKey<FormState>();
  String initvalue = null;
  String currentvalue = null;
  bool autovalidateVal;
  bool autofocusVal = false;

  TextEditingController _marka = TextEditingController();
  TextEditingController _servisAdi = TextEditingController();
  TextEditingController _servisTel = TextEditingController();
  TextEditingController _teknisyenAdi = TextEditingController();
  TextEditingController _tarih = TextEditingController();
  TextEditingController _musteriAd = TextEditingController();
  TextEditingController _musteriTel = TextEditingController();
  TextEditingController _musteriAdres = TextEditingController();
  TextEditingController _cihazSeriNo = TextEditingController();
  TextEditingController _cihazModel = TextEditingController();
  TextEditingController _cihazTip = TextEditingController();
  TextEditingController _parcalar = TextEditingController();
  TextEditingController _yapilanBakim = TextEditingController();
  TextEditingController _yapilanIs = TextEditingController();
  TextEditingController _aciklama = TextEditingController();
  TextEditingController _ucret = TextEditingController();
  bool checkBoxValue = false;
  DateTime now = DateTime.now();
  DateTime last = DateTime(DateTime.now().year, DateTime.now().month - 2);
  DateTime after = DateTime(DateTime.now().year, DateTime.now().month + 2);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autovalidateVal = false;
    tumDokumanListesi = List<Document>();
    _databaseHelper = DatabaseHelper();
    //Yerel Veritabanından veri çekme işlemi
    _databaseHelper.allDocument().then((allDocumentMapList) {
      for (Map docMap in allDocumentMapList) {
        tumDokumanListesi.add(Document.fromMap(docMap));
      }
    });
    for (Document docMap in tumDokumanListesi) {
      debugPrint(docMap.toString());
    }
    _tarih.text = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("Teknik Servis"),
        leading: GestureDetector(
          child: Icon(
            Icons.print,
            size: 36,
          ),
          onLongPress: () => Toast.show(
            "Önizle",
            context,
            duration: 3,
          ),
          onTap: () => _preview(false),
        ),
        actions: [
          GestureDetector(
            child: Icon(
              Icons.history,
              size: 36,
            ),
            onLongPress: () => Toast.show(
              "Önceki Dökümanları Görüntüle",
              context,
              duration: 3,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryDocumentsPage())),
          ),
        ],
        centerTitle: true,
      ),
      body: Form(
        autovalidate: true,
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
                          iconEnabledColor: Colors.white,
                          dropdownColor: Colors.grey.shade800,
                          iconDisabledColor: Colors.white,
                          focusColor: Colors.green,
                          style: TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
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
                            _marka.text = secilen;
                            setState(() {
                              currentvalue = secilen;
                            });
                          },
                          hint: Text(
                            "Marka Seçin",
                            style: TextStyle(color: Colors.white),
                          ),
                          value: currentvalue,
                        ),
                      ),
                      Container(
                        width: 250,
                        child: Column(
                          children: [
                            textBox(
                                "Servis Adı", _servisAdi, TextInputType.text),
                            textBox("Servis Telefon Numarası", _servisTel,
                                TextInputType.text),
                          ],
                        ),
                      )
                    ],
                  ),
                  textBox("Teknisyen Adı", _teknisyenAdi, TextInputType.text),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "  Tarih: ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          RaisedButton(
                            child: Text(
                              _tarih.text,
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.grey.shade700,
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: last,
                                lastDate: after,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: Colors.grey.shade600,
                                      accentColor: Colors.grey.shade600,
                                      colorScheme: ColorScheme.light(
                                          primary: Colors.grey.shade600),
                                      buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary),
                                    ),
                                    child: child,
                                  );
                                },
                              ).then((selectDate) {
                                setState(() {
                                  _tarih.text = formatDate(
                                      selectDate, [dd, '-', mm, '-', yyyy]);
                                });
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  textBox("Müşteri Ad Soyad", _musteriAd, TextInputType.text),
                  textBox("Müşteri Telefon Numarası", _musteriTel,
                      TextInputType.phone),
                  textBox("Müşteri Adres", _musteriAdres, TextInputType.text),
                  textBox("Cihaz Seri No", _cihazSeriNo, TextInputType.text),
                  textBox("Cihaz Model", _cihazModel, TextInputType.text),
                  textBox("Cihaz Tipi", _cihazTip, TextInputType.text),
                  textBox("Kullanılan Parçalar", _parcalar, TextInputType.text),
                  textBox("Yapılan Bakım", _yapilanBakim, TextInputType.text),
                  textBox("Yapılan İşçilik", _yapilanIs, TextInputType.text),
                  textBox("Açıklama", _aciklama, TextInputType.text),
                  textBox("Ücret", _ucret, TextInputType.text),
                  CheckboxListTile(
                    activeColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(120, 4, 120, 0),
                    isThreeLine: false,
                    value: checkBoxValue,
                    onChanged: (secildi) {
                      setState(() {
                        checkBoxValue = secildi;
                      });
                    },
                    title: Text(
                      "Garanti",
                      style: TextStyle(color: Colors.white),
                    ),
                    checkColor: Colors.grey.shade800,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Önizle ve Yazdır",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    onPressed: () {
                      _OnizleVeYazdir();
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Development by Pay-Lee",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "0537 933 8182",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _OnizleVeYazdir() {
    _preview(true);
  }

  void _Kaydet() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      var doc = Document(
          _marka.text,
          _servisAdi.text,
          _servisTel.text,
          _teknisyenAdi.text,
          _tarih.text,
          _musteriAd.text,
          _musteriTel.text,
          _musteriAdres.text,
          _cihazSeriNo.text,
          _cihazModel.text,
          _cihazTip.text,
          _parcalar.text,
          _yapilanBakim.text,
          _yapilanIs.text,
          _aciklama.text,
          _ucret.text,
          checkBoxValue.toString());
      _databaseHelper.addDocument(doc);
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => SelectPrinterPage(doc)))
          .then((initValNull) {
        setState(() {
          formKey.currentState.reset();
          formKey.currentState.deactivate();

          checkBoxValue = false;
        });
      });
    } else {
      setState(() {
        autovalidateVal = true;
        autofocusVal = true;
      });

      Toast.show(
        "Lütfen Müşteri Telefon Numarasını Kontrol Ediniz",
        context,
      );
    }
  }

  String _phoneControl(String value) {
    //String pattern = r'(^[0-9]{10,12}$)';
    RegExp regExp = new RegExp("(05|5)[0-9][0-9][0-9]([0-9]){6,6}");
    if (value.length == 0) {
      return 'Lütfen Telefon Numarası Giriniz';
    } else if (!regExp.hasMatch(value)) {
      return 'Geçersiz Telefon Numarası';
    }
    return null;
  }

  void _preview(bool check) {
    formKey.currentState.save();
    String logoName;

    if (_marka.text == null ||
        _marka.text.toString().toLowerCase() == "demirdöküm")
      logoName = "demirdokum";
    else if (_marka.text == null ||
        _marka.text.toString().toLowerCase() == "arçelik")
      logoName = "arcelik";
    else
      logoName = _marka.text.toString().toLowerCase();

    //print("CheckValue: " + checkBoxValue.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return Container(
              alignment: Alignment.topLeft,
              height: height,
              width: width,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Logo
                  Image.asset(
                    "assets/images/" + logoName + ".png",
                    scale: 0.4,
                  ),
                  Text("YETKILI SERVIS", textAlign: TextAlign.center),
                  Text(""),
                  Text(
                    _servisAdi.text.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _servisTel.text.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  Text(""),
                  Text("Teknisyen Adi : " + _teknisyenAdi.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Tarih : " + _tarih.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Musteri Bilgileri"),
                  Text("Ad Soyad : " + _musteriAd.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Telefon : " + _musteriTel.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Adres : " + _musteriAdres.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Cihaz Bilgileri", textAlign: TextAlign.left),
                  Text("Seri No : " + _cihazSeriNo.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Model : " + _cihazModel.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Tip : " + _cihazTip.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Verilen Hizmetler", textAlign: TextAlign.left),
                  Text("Parcalar : " + _parcalar.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Bakim : " + _yapilanBakim.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Iscilik : " + _yapilanIs.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Aciklama : " + _aciklama.text.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("\n"),
                  checkBoxValue == true
                      ? Text("PARCA VE HIZMETLER 1 YIL GARANTIMIZ ALTINDADIR",
                          textAlign: TextAlign.center)
                      : SizedBox(),
                  Text("\n"),
                  Text("Toplam Ucret : " + _ucret.text + " TL",
                      textAlign: TextAlign.center),

                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [Text("Teknisyen"), Text("Imza")],
                      ),
                      Column(
                        children: [Text("Musteri"), Text("Imza")],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          check == true
              ? RaisedButton(
                  color: Colors.green,
                  child: Text("Yazdır"),
                  onPressed: () {
                    Navigator.pop(context, true);
                    _Kaydet();
                  },
                )
              : SizedBox(),
          RaisedButton(
            color: Colors.red,
            child: Text("Geri Dön"),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      ),
    );
  }

  Widget textBox(String label, TextEditingController textEditingController,
      TextInputType textInputType,
      {Function validatorValue = null}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textEditingController,
        autovalidate: false,
        initialValue: initvalue,
        autofocus: false,
        textInputAction: TextInputAction.done,
        keyboardType: textInputType,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            hintStyle: TextStyle(color: Colors.white),
            labelText: label,
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: Colors.white,
            )),
        validator: (girilen) => null,

      ),
    );
  }
}