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

  List<String> _photos = [];
  List<String> get photos => _photos;
  void addPhoto(String value) {
    _photos.add(value);
  }

  void clearPhotos() {
    _photos.clear();
  }
}
