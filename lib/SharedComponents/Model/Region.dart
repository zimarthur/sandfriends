import 'City.dart';

class Region {
  final int idState;
  final String state;
  final String uf;
  List<City> cities = [];
  City? selectedCity;

  Region({
    required this.idState,
    required this.state,
    required this.uf,
    this.selectedCity,
  });
}

Region regionFromJson(Map<String, dynamic> json) {
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
