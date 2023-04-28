import 'package:sandfriends/models/city.dart';

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
  return newRegion;
}
