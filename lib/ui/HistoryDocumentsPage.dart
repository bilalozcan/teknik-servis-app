import 'package:flutter/material.dart';
import 'package:teknik_servis/model/Document.dart';
import 'package:teknik_servis/utils/DatabaseHelper.dart';
import 'package:toast/toast.dart';

import 'SelectPrinterPage.dart';

class HistoryDocumentsPage extends StatefulWidget {
  @override
  _HistoryDocumentsPageState createState() => _HistoryDocumentsPageState();
}

class _HistoryDocumentsPageState extends State<HistoryDocumentsPage> {
  DatabaseHelper _databaseHelper;
  List<Document> _allDocumentList;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _allDocumentList = List<Document>();
    _databaseHelper.allDocument().then((allDocumentMapList) {
      for (Map docMap in allDocumentMapList) {
        _allDocumentList.add(Document.fromMap(docMap));
      }
      setState(() {
        _allDocumentList;
      });
    }).catchError((error) => print("Hata" + error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
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
        title: Text("Önceki Yazdırılanlar"),
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
                      _allDocumentList[index].musteriAd,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    subtitle: Text(
                      _allDocumentList[index].musteriTel,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    leading: GestureDetector(
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 36,
                      ),
                      onTap: () => _deleteDocument(
                          _allDocumentList[index].id.toString(), index),
                    ),
                    trailing: GestureDetector(
                      child: Icon(
                        Icons.print,
                        color: Colors.white,
                        size: 36,
                      ),
                      onTap: () {
                        _preview(_allDocumentList[index], true);
                        debugPrint("Print onTap");
                      },
                    ),
                  ),
                ),
                onTap: () {
                  _preview(_allDocumentList[index], false);
                },
              );
            },
            itemCount: _allDocumentList.length,
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
                  _allDocumentList.clear();
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
    var sonuc = await _databaseHelper.deleteDocument(id);
    if (sonuc == 1) {
      Toast.show("Bir eski kayıt silindi", context);
      setState(() {
        _allDocumentList.removeAt(index);
      });
    } else {
      Toast.show("HATA", context);
    }
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
                  Text("YETKILI SERVIS", textAlign: TextAlign.center),
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
                            builder: (context) => SelectPrinterPage(document)));
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
