import 'package:sandfriends/models/court_available_hours.dart';

class Court {
  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = value;
  }

  String _day = "sf";
  String get day => _day;
  set day(String value) {
    _day = value;
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

  List<CourtAvailableHours> availableHours = [];

  /*factory Court.fromJson(Map<String, dynamic> json) {
    return new Court(json["name"], json["address"], json["imageURL"]);
  }*/
}
