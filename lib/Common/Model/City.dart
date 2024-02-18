import 'package:sandfriends/Common/Model/Region.dart';

class City {
  final int cityId;
  String name;
  final Region? state;

  City({
    required this.cityId,
    required this.name,
    this.state,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['IdCity'],
      name: json['City'],
      //state: regionFromJson(json['State']),
    );
  }

  factory City.fromJsonUser(Map<String, dynamic> json) {
    return City(
      cityId: json['IdCity'],
      name: json['City'],
      state: Region.fromJsonUser(
        json['State'],
      ),
    );
  }
}
