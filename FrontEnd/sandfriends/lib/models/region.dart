import 'package:sandfriends/models/city.dart';

class Region {
  final String state;
  final String uf;
  List<City> cities = [];
  City? selectedCity;

  Region({
    required this.state,
    required this.uf,
  });
}
