class Document {
  int _id;
  String _marka;
  String _servisAdi;
  String _servisTel;
  String _teknisyenAdi;
  String _tarih;
  String _musteriAd;
  String _musteriTel;
  String _musteriAdres;
  String _cihazSeriNo;
  String _cihazModel;
  String _cihazTip;
  String _parcalar;
  String _yapilanBakim;
  String _yapilanIs;
  String _aciklama;
  String _ucret;
  String _garanti;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get marka => _marka;

  set marka(String value) {
    _marka = value;
  }

  String get servisAdi => _servisAdi;

  String get garanti => _garanti;

  set garanti(String value) {
    _garanti = value;
  }

  String get ucret => _ucret;

  set ucret(String value) {
    _ucret = value;
  }

  String get aciklama => _aciklama;

  set aciklama(String value) {
    _aciklama = value;
  }

  String get yapilanIs => _yapilanIs;

  set yapilanIs(String value) {
    _yapilanIs = value;
  }

  String get yapilanBakim => _yapilanBakim;

  set yapilanBakim(String value) {
    _yapilanBakim = value;
  }

  String get parcalar => _parcalar;

  set parcalar(String value) {
    _parcalar = value;
  }

  String get cihazTip => _cihazTip;

  set cihazTip(String value) {
    _cihazTip = value;
  }

  String get cihazModel => _cihazModel;

  set cihazModel(String value) {
    _cihazModel = value;
  }

  String get cihazSeriNo => _cihazSeriNo;

  set cihazSeriNo(String value) {
    _cihazSeriNo = value;
  }

  String get musteriAdres => _musteriAdres;

  set musteriAdres(String value) {
    _musteriAdres = value;
  }

  String get musteriTel => _musteriTel;

  set musteriTel(String value) {
    _musteriTel = value;
  }

  String get musteriAd => _musteriAd;

  set musteriAd(String value) {
    _musteriAd = value;
  }

  String get tarih => _tarih;

  set tarih(String value) {
    _tarih = value;
  }

  String get teknisyenAdi => _teknisyenAdi;

  set teknisyenAdi(String value) {
    _teknisyenAdi = value;
  }

  String get servisTel => _servisTel;

  set servisTel(String value) {
    _servisTel = value;
  }

  set servisAdi(String value) {
    _servisAdi = value;
  }

  Document(
      this._marka,
      this._servisAdi,
      this._servisTel,
      this._teknisyenAdi,
      this._tarih,
      this._musteriAd,
      this._musteriTel,
      this._musteriAdres,
      this._cihazSeriNo,
      this._cihazModel,
      this._cihazTip,
      this._parcalar,
      this._yapilanBakim,
      this._yapilanIs,
      this._aciklama,
      this._ucret,
      this._garanti);

  Document.withID(
      this._id,
      this._marka,
      this._servisAdi,
      this._servisTel,
      this._teknisyenAdi,
      this._tarih,
      this._musteriAd,
      this._musteriTel,
      this._musteriAdres,
      this._cihazSeriNo,
      this._cihazModel,
      this._cihazTip,
      this._parcalar,
      this._yapilanBakim,
      this._yapilanIs,
      this._aciklama,
      this._ucret,
      this._garanti);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['marka'] = _marka;
    map['servisAdi'] = _servisAdi;
    map['servisTel'] = _servisTel;
    map['teknisyenAdi'] = _teknisyenAdi;
    map['tarih'] = _tarih;
    map['musteriAd'] = _musteriAd;
    map['musteriTel'] = _musteriTel;
    map['musteriAdres'] = _musteriAdres;
    map['cihazSeriNo'] = _cihazSeriNo;
    map['cihazModel'] = _cihazModel;
    map['cihazTip'] = _cihazTip;
    map['parcalar'] = _parcalar;
    map['yapilanBakim'] = _yapilanBakim;
    map['yapilanIs'] = _yapilanIs;
    map['aciklama'] = _aciklama;
    map['ucret'] = _ucret;
    map['garanti'] = _garanti;
    return map;
  }

  Document.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._marka = map['marka'];
    this._servisAdi = map['servisAdi'];
    this._servisTel = map['servisTel'];
    this._teknisyenAdi = map['teknisyenAdi'];
    this._tarih = map['tarih'];
    this._musteriAd = map['musteriAd'];
    this._musteriTel = map['musteriTel'];
    this._musteriAdres = map['musteriAdres'];
    this._cihazSeriNo = map['cihazSeriNo'];
    this._cihazModel = map['cihazModel'];
    this._cihazTip = map['cihazTip'];
    this._parcalar = map['parcalar'];
    this._yapilanBakim = map['yapilanBakim'];
    this._yapilanIs = map['yapilanIs'];
    this._aciklama = map['aciklama'];
    this._ucret = map['ucret'];
    this._garanti = map['garanti'];
  }

  @override
  String toString() {
    // TODO: implement toString
    return ("ID: $_id " +
        "Marka: $_marka " +
        "Servis Adı: $_servisAdi " +
        "Servis Tel: $_servisTel " +
        "Teknisyen: $_teknisyenAdi " +
        "Tarih: $_tarih " +
        "Musteri Adı: $_musteriAd " +
        "Musteri Tel: $_musteriTel " +
        "Musteri Adres: $_musteriAdres " +
        "Cihaz Seri No: $_cihazSeriNo " +
        "Cihaz Model: $_cihazModel " +
        "Cihaz Tipi: $_cihazTip " +
        "Parcalar: $_parcalar " +
        "Yapılan Bakım: $_yapilanBakim " +
        "Yapılan İş: $_yapilanIs " +
        "Açıklama: $_aciklama " +
        "Ucret: $_ucret " +
        "Garanti: $_garanti");
  }
}
