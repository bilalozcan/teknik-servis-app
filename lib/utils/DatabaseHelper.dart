import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:teknik_servis/model/Document.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String _documentTable = "document";

  String columnID = 'id';
  String columnMarka = 'marka';
  String columnServisAdi = 'servisAdi';
  String columnServisTel = 'servisTel';
  String columnTeknisyenAdi = 'teknisyenAdi';
  String columnTarih = 'tarih';
  String columnMusteriAd = 'musteriAd';
  String columnMusteriTel = 'musteriTel';
  String columnMusteriAdres = 'musteriAdres';
  String columnCihazSeriNo = 'cihazSeriNo';
  String columnCihazModel = 'cihazModel';
  String columnCihazzTip = 'cihazTip';
  String columnParcalar = 'parcalar';
  String columnYapilanBakim = 'yapilanBakim';
  String columnYapilanIs = 'yapilanIs';
  String columnAciklama = 'aciklama';
  String columnUcret = 'ucret';
  String columnGaranti = 'garanti';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else
      return _databaseHelper;
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = join(klasor.path, "document_createDB");
    var documentDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
    return documentDB;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_documentTable ($columnID INTEGER PRIMARY KEY AUTOINCREMENT,"
        " $columnMarka TEXT,"
        " $columnServisAdi TEXT,"
        " $columnServisTel TEXT,"
        " $columnTeknisyenAdi TEXT,"
        " $columnTarih TEXT,"
        " $columnMusteriAd TEXT,"
        " $columnMusteriTel TEXT,"
        " $columnMusteriAdres TEXT,"
        " $columnCihazSeriNo TEXT,"
        " $columnCihazModel TEXT,"
        " $columnCihazzTip TEXT,"
        " $columnParcalar TEXT,"
        " $columnYapilanBakim TEXT,"
        " $columnYapilanIs TEXT,"
        " $columnAciklama TEXT,"
        " $columnUcret TEXT,"
        " $columnGaranti TEXT )");
  }

  Future<int> addDocument(Document document) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(_documentTable, document.toMap(),
        nullColumnHack: "$columnID");
    return sonuc;
  }

  Future<int> deleteDocument(String id) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete(_documentTable, where: '$columnID = ? ', whereArgs: [id]);
    return sonuc;
  }

  Future<int> deleteAllDocument() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_documentTable);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> allDocument() async {
    var db = await _getDatabase();
    var sonuc = await db.query(_documentTable, orderBy: '$columnID DESC');
    return sonuc;
  }
}
