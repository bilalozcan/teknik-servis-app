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
    _tarih = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
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
                            _marka = secilen;
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: initvalue,
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
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
                                initialValue: initvalue,
                                autofocus: false,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
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
                      initialValue: initvalue,
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
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
                              formatDate(
                                  DateTime.now(), [dd, '-', mm, '-', yyyy]),
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
                                _tarih = formatDate(
                                    selectDate, [dd, '-', mm, '-', yyyy]);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: initvalue,
                      autofocus: false,
                      keyboardType: TextInputType.text,
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
                      initialValue: initvalue,
                      autovalidate: autovalidateVal,
                      autofocus: autofocusVal,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
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
                      validator: _phoneControl,
                      onSaved: (value) => _musteriTel = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: initvalue,
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
                      initialValue: initvalue,
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
                      initialValue: initvalue,
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
                      initialValue: initvalue,
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
                      initialValue: initvalue,
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
                      initialValue: initvalue,
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
                      initialValue: initvalue,
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
                      initialValue: initvalue,
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
                      autovalidate: false,
                      initialValue: initvalue,
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
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
                    "bilalozcan015@gmail.com",
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
          checkBoxValue.toString());
      _databaseHelper.addDocument(doc);
      debugPrint("CheckBox Value: " + checkBoxValue.toString());
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

    if (_marka == null || _marka.toString().toLowerCase() == "demirdöküm")
      logoName = "demirdokum";
    else if (_marka == null || _marka.toString().toLowerCase() == "arçelik")
      logoName = "arcelik";
    else
      logoName = _marka.toString().toLowerCase();

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
                    _servisAdi.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _servisTel.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  Text(""),
                  Text("Teknisyen Adi : " + _teknisyenAdi.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Tarih : " + _tarih.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Musteri Bilgileri"),
                  Text("Ad Soyad : " + _musteriAd.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Telefon : " + _musteriTel.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Adres : " + _musteriAdres.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Cihaz Bilgileri", textAlign: TextAlign.left),
                  Text("Seri No : " + _cihazSeriNo.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Model : " + _cihazModel.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Tip : " + _cihazTip.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Verilen Hizmetler", textAlign: TextAlign.left),
                  Text("Parcalar : " + _parcalar.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Bakim : " + _yapilanBakim.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Iscilik : " + _yapilanIs.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Aciklama : " + _aciklama.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("\n"),
                  checkBoxValue == true
                      ? Text("PARCA VE HIZMETLER 1 YIL GARANTIMIZ ALTINDADIR",
                          textAlign: TextAlign.center)
                      : SizedBox(),
                  Text("\n"),
                  Text("Toplam : " + _ucret, textAlign: TextAlign.center),

                  SizedBox(
                    height: 8,
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
}
