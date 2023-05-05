import 'package:sandfriends/SharedComponents/Model/Region.dart';

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

  factory City.fromJsonUser(Map<String, dynamic> json) {
    return City(
      cityId: json['IdCity'],
      city: json['City'],
      state: Region.fromJsonUser(
        json['State'],
      ),
    );
  }
}
