import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:teknik_servis/model/Document.dart';
import 'package:teknik_servis/utils/DatabaseHelper.dart';
import 'package:toast/toast.dart';
import 'PrinterPage.dart';

class HistoryDocumentsPage extends StatefulWidget {
  @override
  _HistoryDocumentsPageState createState() => _HistoryDocumentsPageState();
}

class _HistoryDocumentsPageState extends State<HistoryDocumentsPage> {
  DatabaseHelper _databaseHelper;
  List<Document> _documentList;
  var _tarih;
  DateTime now = DateTime.now();
  DateTime last = DateTime(DateTime.now().year - 2, DateTime.now().month);
  DateTime after = DateTime(DateTime.now().year + 2, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    _tarih = DateTime.now();
    _databaseHelper = DatabaseHelper();
    _documentList = List<Document>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 8),
            width: 105,
            height: 10,
            child: RaisedButton(
              color: Colors.red.shade700,
              child: Text("Hepsini Göster", style: TextStyle(color: Colors.white),),
              onPressed: () {
                _documentList.clear();
                _databaseHelper.allDocument().then((allDocumentMapList) {
                  for (Map docMap in allDocumentMapList) {
                    _documentList.add(Document.fromMap(docMap));
                  }
                }).catchError((error) => print("Hata" + error));
                setState(() {
                  _documentList;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 2, top: 12, bottom: 12),
            child: RaisedButton(
              child: Text(formatDate(_tarih, [dd, '-', mm, '-', yyyy])),
              onPressed: () {
                showDatePicker(
                  context: context,
                  currentDate: _tarih,
                  initialDate: _tarih,
                  firstDate: last,
                  lastDate: after,
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.grey.shade600,
                        accentColor: Colors.grey.shade600,
                        colorScheme:
                            ColorScheme.light(primary: Colors.grey.shade600),
                        buttonTheme:
                            ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child,
                    );
                  },
                ).then((selectDate) {
                  setState(() {
                    _tarih = selectDate;
                    _documentList.clear();
                    _databaseHelper
                        .getDocumentWithDate(
                            formatDate(_tarih, [dd, '-', mm, '-', yyyy]))
                        .then((allDocumentMapList) {
                      for (Map docMap in allDocumentMapList) {
                        _documentList.add(Document.fromMap(docMap));
                      }
                      setState(() {
                        _documentList;
                      });
                    }).catchError((error) => print("Hata" + error));
                  });
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              child: Icon(
                Icons.delete,
                size: 30,
              ),
              onTap: _deleteAllDocument,
              onLongPress: () => Toast.show(
                "Dökümanları Sil",
                context,
                duration: 3,
              ),
            ),
          ),
        ],
        title: Text("Kayıtlar"),
      ),
      body: Container(
          color: Colors.grey.shade800,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  color: Colors.grey.shade600,
                  child: ListTile(
                    title: Text(
                      _documentList[index].musteriAd,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    subtitle: Text(
                      _documentList[index].musteriTel,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    leading: GestureDetector(
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 36,
                      ),
                      onTap: () => _deleteDocument(
                          _documentList[index].id.toString(), index),
                    ),
                    trailing: GestureDetector(
                      child: Icon(
                        Icons.print,
                        color: Colors.white,
                        size: 36,
                      ),
                      onTap: () {
                        _preview(_documentList[index], true);
                        debugPrint("Print onTap");
                      },
                    ),
                  ),
                ),
                onTap: () {
                  _preview(_documentList[index], false);
                },
              );
            },
            itemCount: _documentList.length,
          )),
    );
  }

  void _deleteAllDocument() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bütün Geçmiş Silinsin Mi?"),
          actions: [
            FlatButton(
              child: Text("Evet"),
              onPressed: () async {
                await _databaseHelper.deleteAllDocument();
                Toast.show("Tüm eski kayıtlar silindi", context);
                setState(() {
                  _documentList.clear();
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _deleteDocument(String id, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Kayıt Silinsin Mi?"),
          actions: [
            FlatButton(
              child: Text("Evet"),
              onPressed: () async {
                await _databaseHelper.deleteDocument(id);
                Toast.show("Kayıt silindi", context);
                setState(() {
                  _documentList.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _preview(Document document, bool check) {
    String logoName;

    if (document.marka == null ||
        document.marka.toString().toLowerCase() == "demirdöküm")
      logoName = "demirdokum";
    else if (document.marka == null ||
        document.marka.toString().toLowerCase() == "arçelik")
      logoName = "arcelik";
    else
      logoName = document.marka.toString().toLowerCase();

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
                  Text("TEKNIK SERVIS", textAlign: TextAlign.center),
                  Text(""),
                  Text(
                    document.servisAdi.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    document.servisTel.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  Text(""),
                  Text("Teknisyen Adi : " + document.teknisyenAdi.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Tarih : " + document.tarih.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Musteri Bilgileri"),
                  Text("Ad Soyad : " + document.musteriAd.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Telefon : " + document.musteriTel.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Adres : " + document.musteriAdres.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Cihaz Bilgileri", textAlign: TextAlign.left),
                  Text("Seri No : " + document.cihazSeriNo.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Model : " + document.cihazModel.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Tip : " + document.cihazTip.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text(""),
                  Text("Verilen Hizmetler", textAlign: TextAlign.left),
                  Text("Parcalar : " + document.parcalar.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Bakim : " + document.yapilanBakim.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Iscilik : " + document.yapilanIs.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("Aciklama : " + document.aciklama.toUpperCase(),
                      textAlign: TextAlign.left),
                  Text("\n"),
                  document.garanti == "true"
                      ? Text("PARCA VE HIZMETLER 1 YIL GARANTIMIZ ALTINDADIR",
                          textAlign: TextAlign.center)
                      : SizedBox(),
                  Text("\n"),
                  Text("Toplam Ucret : " + document.ucret + " TL",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrinterPage(document)));
                  })
              : SizedBox(),
          RaisedButton(
            color: Colors.red,
            child: Text("Geri Dön"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}
