import 'dart:io';
import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:teknik_servis/model/Document.dart';
import 'package:toast/toast.dart';

class PrinterPage extends StatefulWidget {
  Document _document;

  PrinterPage(this._document);

  @override
  _PrinterPageState createState() => _PrinterPageState(_document);
}

class _PrinterPageState extends State<PrinterPage> {
  Document _document;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;

  _PrinterPageState(this._document);

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSavetoPath();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    var logoName;
    if (_document.marka == "" ||
        _document.marka.toString().toLowerCase() == "demirdöküm")
      logoName = "demirdokum";
    else if (_document.marka.toString().toLowerCase() == "arçelik")
      logoName = "arcelik";
    else
      logoName = _document.marka.toString().toLowerCase();
    final filename = logoName;
    var bytes = await rootBundle.load("assets/images/" + logoName + ".png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
    });
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YAZDIR'),
      ),
      body: Container(
        color: Colors.grey.shade800,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Cihaz:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButton(
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.grey.shade800,
                      iconDisabledColor: Colors.white,
                      focusColor: Colors.green,
                      style: TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                      items: _getDeviceItems(),
                      onChanged: (value) => setState(() => _device = value),
                      value: _device,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.red.shade900,
                    onPressed: () {
                      initPlatformState();
                    },
                    child: Text(
                      'Yenile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: _connected ? Colors.red : Colors.green,
                    onPressed: _connected ? _disconnect : _connect,
                    child: Text(
                      _connected ? 'Bağlantıyı Kes' : 'Bağlan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                child: RaisedButton(
                  color: Colors.black54,
                  onPressed: () {
                    sample(pathImage);
                    Toast.show("Yazdırılıyor...", context, duration: 3);
                  },
                  child: Text('YAZDIR', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text(
          'CİHAZ YOK',
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('Cihaz Seçilmedi.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
          Toast.show("Bağlanıyor...", context, duration: 4);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

  //write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  sample(String pathImage) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    //var response = await http.get("IMAGE_URL");
    //Uint8List bytes = response.bodyBytes;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printNewLine();
        bluetooth.printImage(pathImage); //path of your image/logo
        bluetooth.printNewLine();
        bluetooth.printCustom("TEKNIK SERVIS", 2, 1, charset: "CP857");
        bluetooth.printNewLine();
        bluetooth.printCustom(
            _document.servisAdi
                .replaceAll(RegExp(r'ğ'), 'g')
                .replaceAll(RegExp(r'ş'), 's')
                .replaceAll(RegExp(r'ı'), 'i')
                .replaceAll(RegExp(r'ç'), 'C')
                .replaceAll(RegExp(r'İ'), 'I')
                .replaceAll(RegExp(r'Ğ'), 'G')
                .replaceAll(RegExp(r'Ş'), 'S')
                .replaceAll(RegExp(r'Ç'), 'C')
                .toUpperCase(),
            1,
            1,
            charset: "CP857");
        bluetooth.printCustom(_document.servisTel, 1, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "    Teknisyen Adi: " +
                _document.teknisyenAdi
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase(),
            0,
            0,
            charset: "CP857");
        bluetooth.printCustom(
            "    Tarih: " + _document.tarih.toUpperCase(), 0, 0,
            charset: "CP857");
        bluetooth.printNewLine();
        bluetooth.printCustom("    Müsteri Bilgileri", 0, 0, charset: "CP857");
        bluetooth.printCustom(
            "    Ad Soyad: " +
                _document.musteriAd
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase(),
            0,
            0,
            charset: "CP857");
        bluetooth.printCustom("    Telefon: " + _document.musteriTel, 0, 0,
            charset: "CP857");
        var adres = "Adres: " +
            _document.musteriAdres
                .replaceAll(RegExp(r'ğ'), 'g')
                .replaceAll(RegExp(r'ş'), 's')
                .replaceAll(RegExp(r'ı'), 'i')
                .replaceAll(RegExp(r'ç'), 'C')
                .replaceAll(RegExp(r'İ'), 'I')
                .replaceAll(RegExp(r'Ğ'), 'G')
                .replaceAll(RegExp(r'Ş'), 'S')
                .replaceAll(RegExp(r'Ç'), 'C')
                .toUpperCase();
        int startIndex = 0;
        int lastIndex = 46;
        while (true) {
          if (startIndex < adres.length && lastIndex < adres.length) {
            bluetooth.printCustom(
                "    " + adres.substring(startIndex, lastIndex), 0, 0,
                charset: "CP857");
            startIndex += 46;
            lastIndex += 46;
          } else if (lastIndex > adres.length) {
            lastIndex = adres.length;
            bluetooth.printCustom(
                "    " + adres.substring(startIndex, lastIndex), 0, 0,
                charset: "CP857");
            startIndex += 46;
          } else {
            break;
          }
        }
        //bluetooth.printCustom("    Adres: " + _document.musteriAdres.toUpperCase(), 0, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("    Cihaz Bilgileri", 0, 0, charset: "CP857");
        bluetooth.printCustom(
            "    Seri No: " + _document.cihazSeriNo.toUpperCase(), 0, 0,
            charset: "CP857");
        bluetooth.printCustom(
            "    Model: " +
                _document.cihazModel
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase(),
            0,
            0,
            charset: "CP857");
        bluetooth.printCustom(
            "    Tip: " +
                _document.cihazTip
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase(),
            0,
            0,
            charset: "CP857");
        bluetooth.printNewLine();
        bluetooth.printCustom("    Verilen Hizmetler", 0, 0, charset: "CP857");
        bluetooth.printCustom(
            "    Parcalar: " +
                _document.parcalar
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase(),
            0,
            0,
            charset: "CP857");
        bluetooth.printCustom(
            "    Bakim: " +
                _document.yapilanBakim
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase(),
            0,
            0,
            charset: "CP857");
        bluetooth.printCustom(
            "    Iscilik: " +
                _document.yapilanIs
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase(),
            0,
            0,
            charset: "CP857");
        String aciklama =
            "Aciklama: " +
                _document.aciklama
                    .replaceAll(RegExp(r'ğ'), 'g')
                    .replaceAll(RegExp(r'ş'), 's')
                    .replaceAll(RegExp(r'ı'), 'i')
                    .replaceAll(RegExp(r'ç'), 'C')
                    .replaceAll(RegExp(r'İ'), 'I')
                    .replaceAll(RegExp(r'Ğ'), 'G')
                    .replaceAll(RegExp(r'Ş'), 'S')
                    .replaceAll(RegExp(r'Ç'), 'C')
                    .toUpperCase();
        startIndex = 0;
        lastIndex = 46;
        while (true) {
          if (startIndex < aciklama.length && lastIndex < aciklama.length) {
            bluetooth.printCustom(
                "    " + aciklama.substring(startIndex, lastIndex), 0, 0,
                charset: "CP857");
            startIndex += 46;
            lastIndex += 46;
          } else if (lastIndex > aciklama.length) {
            lastIndex = aciklama.length;
            bluetooth.printCustom(
                "    " + aciklama.substring(startIndex, lastIndex), 0, 0,
                charset: "CP857");
            startIndex += 46;
          } else {
            break;
          }
        }
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        if (_document.garanti == "true") {
          bluetooth.printCustom("PARCA VE HIZMETLER 1 YIL", 1, 1,
              charset: "CP857");
          bluetooth.printCustom("BOYUNCA GARANTIMIZ ALTINDADIR", 1, 1,
              charset: "CP857");
          bluetooth.printNewLine();
          bluetooth.printNewLine();
        }
        bluetooth.printCustom("Toplam Ücret: " + _document.ucret + " TL", 0, 1,
            charset: "CP857");
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Teknisyen", "Müsteri", 0, charset: "CP857");
        bluetooth.printLeftRight("  Imza", " Imza ", 0, charset: "CP857");
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }
}
