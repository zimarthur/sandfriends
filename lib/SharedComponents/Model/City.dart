import 'package:sandfriends/oldApp/models/region.dart';

class City {
  final int cityId;
  final String city;
  final Region? state;

  City({
    required this.cityId,
    required this.city,
    this.state,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['IdCity'],
      city: json['City'],
      //state: regionFromJson(json['State']),
    );
  }
}
