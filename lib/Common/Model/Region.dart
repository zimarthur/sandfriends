import 'City.dart';

class Region {
  final int idState;
  final String state;
  String uf;
  List<City> cities = [];
  City? selectedCity;

  Region({
    required this.idState,
    required this.state,
    required this.uf,
    this.selectedCity,
  });
  bool containsCity(int cityId) {
    return cities.any((city) => city.cityId == cityId);
  }

  factory Region.fromJson(Map<String, dynamic> json) {
    var newRegion = Region(
      idState: json['IdState'],
      state: json['State'],
      uf: json['UF'],
    );
    for (var city in json['Cities']) {
      newRegion.cities.add(
        City.fromJson(
          city,
        ),
      );
    }
    return newRegion;
  }

  factory Region.fromJsonUser(Map<String, dynamic> json) {
    return Region(
      idState: json['IdState'],
      state: json['State'],
      uf: json['UF'],
    );
  }
}
