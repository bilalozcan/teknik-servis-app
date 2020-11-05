import 'package:flutter/material.dart';
import 'package:teknik_servis/model/Document.dart';
import 'package:teknik_servis/utils/DatabaseHelper.dart';
import 'package:toast/toast.dart';

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
              return Card(
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
                  trailing: Icon(
                    Icons.print,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
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
}
