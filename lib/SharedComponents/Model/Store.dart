class Store {
  final int idStore;
  final String name;
  final String address;
  final String latitude;
  final String longitude;
  final String imageUrl;
  final String descriptionText;
  final String instagram;
  final String phone;
  List<String> photos = [];

  Store({
    required this.idStore,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.descriptionText,
    required this.instagram,
    required this.phone,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    var newStore = Store(
      idStore: json['IdStore'],
      name: json['Name'],
      address: json['Address'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
      imageUrl: json['Logo'],
      descriptionText: json['Description'],
      instagram: json['Instagram'],
      phone: json['PhoneNumber1'],
    );
    for (int i = 0; i < json['StorePhotos'].length; i++) {
      newStore.photos.add(json['StorePhotos'][i]['Photo']);
    }
    return newStore;
  }
}
