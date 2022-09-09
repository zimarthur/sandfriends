class Store {
  int _idStore = 0;
  int get idStore => _idStore;
  set idStore(int value) {
    _idStore = value;
  }

  String _name = "sf";
  String get name => _name;
  set name(String value) {
    _name = value;
  }

  String _address = "sf";
  String get address => _address;
  set address(String value) {
    _address = value;
  }

  String _latitude = "sf";
  String get latitude => _latitude;
  set latitude(String value) {
    _latitude = value;
  }

  String _longitude = "sf";
  String get longitude => _longitude;
  set longitude(String value) {
    _longitude = value;
  }

  String _imageUrl = "sf";
  String get imageUrl => _imageUrl;
  set imageUrl(String value) {
    _imageUrl = value;
  }

  String _descriptionText = "sf";
  String get descriptionText => _descriptionText;
  set descriptionText(String value) {
    _descriptionText = value;
  }

  String _instagram = "sf";
  String get instagram => _instagram;
  set instagram(String value) {
    _instagram = value;
  }

  String _phone = "sf";
  String get phone => _phone;
  set phone(String value) {
    _phone = value;
  }

  List<String> _photos = [];
  List<String> get photos => _photos;
  void addPhoto(String value) {
    _photos.add(value);
  }

  void clearPhotos() {
    _photos.clear();
  }
}
