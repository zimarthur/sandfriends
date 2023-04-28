import 'package:sandfriends/models/region.dart';

class City {
  final int cityId;
  final String city;
  final Region? state;

  City({
    required this.cityId,
    required this.city,
    this.state,
  });
}

City cityFromJson(Map<String, dynamic> json) {
  var newCity = City(
    cityId: json['IdCity'],
    city: json['City'],
    state: regionFromJson(json['State']),
  );
  return newCity;
}
