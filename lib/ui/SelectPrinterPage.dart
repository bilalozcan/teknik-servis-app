import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:image/image.dart';
import 'package:teknik_servis/model/Document.dart';
import 'package:toast/toast.dart';

class SelectPrinterPage extends StatefulWidget {
  Document _document;

  SelectPrinterPage(this._document);

  @override
  _SelectPrinterPageState createState() => _SelectPrinterPageState(_document);
}

class _SelectPrinterPageState extends State<SelectPrinterPage> {
  Document _document;
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  //BluetoothDevice bluetoothDevice = BluetoothDevice();

  String _devicesMsg;

  _SelectPrinterPageState(this._document);

  @override
  void initState() {
    initPrinter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yazıcı Seçiniz"),
      ),
      body: _devices.isEmpty
          ? Center(
              child: Text(_devicesMsg ?? ''),
            )
          : Container(
              color: Colors.grey.shade800,
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    leading: Icon(
                      Icons.print,
                      color: Colors.white,
                    ),
                    title: Text(
                      _devices[i].name,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _devices[i].address,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _startPrint(_devices[i]);
                    },
                  );
                },
              ),
            ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 10));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      //bluetoothDevice.name = "Redmi8";
      //bluetoothDevice.address = "60:AB:67:51:F6:4E";
      //val.add(PrinterBluetooth(bluetoothDevice));
      setState(() => _devices = val);
      if (_devices.isEmpty) setState(() => _devicesMsg = "No Devices");
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    Toast.show("Yazdırılıyor...", context, duration: 3);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    print("Result: " + result.toString());
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    var logoName;
    if (_document.marka == null ||_document.marka.toString().toLowerCase() == "demirdöküm")
      logoName = "demirdokum";
    else if (_document.marka == null || _document.marka.toString().toLowerCase() == "arçelik")
      logoName = "arcelik";
    else
      logoName = _document.marka.toString().toLowerCase();
    // Print image
    final ByteData data =
    await rootBundle.load("assets/images/" + logoName + ".png");
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.text("");
    ticket.text("");
    ticket.image(image, align: PosAlign.center);
    ticket.text("YETKILI SERVIS", styles: PosStyles(align: PosAlign.center));
    ticket.text("");
    ticket.text(_document.servisAdi.toUpperCase(),
        styles: PosStyles(align: PosAlign.center));
    ticket.text(_document.servisTel, styles: PosStyles(align: PosAlign.center));
    ticket.text("");
    ticket.text("Teknisyen Adi : " + _document.teknisyenAdi.toUpperCase(),
        styles: PosStyles(
          align: PosAlign.left,
        ));
    ticket.text("Tarih : " + _document.tarih,
        styles: PosStyles(align: PosAlign.left));
    ticket.text("");
    ticket.text("");
    ticket.text("Musteri Bilgileri");
    ticket.text("Ad Soyad : " + _document.musteriAd.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("Telefon : " + _document.musteriTel,
        styles: PosStyles(align: PosAlign.left));
    ticket.text("Adres : " + _document.musteriAdres.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("");
    ticket.text("");
    ticket.text("Cihaz Bilgileri");
    ticket.text("Seri No : " + _document.cihazSeriNo.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("Model : " + _document.cihazModel.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("Tip : " + _document.cihazTip.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("");
    ticket.text("");
    ticket.text("Verilen Hizmetler");
    ticket.text("Parcalar : " + _document.parcalar.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("Bakim : " + _document.yapilanBakim.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("Iscilik : " + _document.yapilanIs.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("Aciklama : " + _document.aciklama.toUpperCase(),
        styles: PosStyles(align: PosAlign.left));
    ticket.text("");
    if (_document.garanti == "true")
      ticket.text(
        "PARCA VE HIZMETLER 1 YIL",
        styles: PosStyles(align: PosAlign.center,)
      );
    ticket.text(
        "GARANTIMIZ ALTINDADIR",
        styles: PosStyles(align: PosAlign.center,)
    );
    ticket.text("");
    ticket.text("   Toplam Ucret: " + _document.ucret + " TL",
        styles: PosStyles(align: PosAlign.center));

    ticket.text("");
    ticket.text("     Teknisyen         Musteri",
        styles: PosStyles(align: PosAlign.left));
    ticket.text("       Imza             Imza",
        styles: PosStyles(align: PosAlign.left));
    ticket.cut();
    return ticket;
  }

  Future<void> documentPrint(Ticket ticket) async {

  }

  Future<void> testModePrint(Ticket ticket) async {
    String na = "TEST_MODE";
    //var logoName = _document.marka.toString().toLowerCase();
    // Print image
    final ByteData data = await rootBundle.load("assets/images/buderus.png");
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.image(image, align: PosAlign.center);
    ticket.text(_document.servisAdi, styles: PosStyles(align: PosAlign.center));
    ticket.text(_document.servisTel, styles: PosStyles(align: PosAlign.center));
    ticket.text("");
    ticket.text("");
    ticket.text("Teknisyen Adi : " + _document.teknisyenAdi,
        styles: PosStyles(
          align: PosAlign.left,
        ));
    ticket.text("Tarih : " + _document.tarih,
        styles: PosStyles(align: PosAlign.left));
    ticket.text("\n");
    ticket.text("Musteri Bilgileri");
    ticket.text("Ad Soyad : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("Telefon : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("Adres : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("\n");
    ticket.text("Cihaz Bilgileri");
    ticket.text("Seri No : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("Model : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("Tip : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("\n");
    ticket.text("Verilen Hizmetler");
    ticket.text("Parcalar : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("Bakim : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("Iscilik : " + na, styles: PosStyles(align: PosAlign.left));
    ticket.text("Aciklama : \n\n" + na,
        styles: PosStyles(align: PosAlign.left));
    ticket.text("\t\t\tToplam : " + na,
        styles: PosStyles(align: PosAlign.center));
    if (_document.garanti == "1")
      ticket.text(
        "Parca ve hizmetler 1 yil garantimiz altindadir",
        styles: PosStyles(align: PosAlign.left, height: PosTextSize.size8),
        maxCharsPerLine: 100,
      );
    ticket.text("\tTeknisyen \t\t\t Musteri",
        styles: PosStyles(align: PosAlign.left));
    ticket.text("\t  Imza \t\t\t Imza",
        styles: PosStyles(align: PosAlign.left));
  }
}
