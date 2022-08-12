import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User with ChangeNotifier {
  String? FirstName;
  String? LastName;
  String? PhoneNumber;
  String? Gender;
  String? Birthday;
  String? Rank;
  double? Height;
  String? HandPreference;
  String? Photo;
}

void userFromJson(BuildContext context, Map<String, dynamic> json) {
  Provider.of<User>(context, listen: false).FirstName = json['FirstName'];
  Provider.of<User>(context, listen: false).LastName = json['LastName'];
  Provider.of<User>(context, listen: false).Gender = json['Gender'];
  Provider.of<User>(context, listen: false).PhoneNumber = json['PhoneNumber'];
  Provider.of<User>(context, listen: false).Birthday = json['Birthday'];
  Provider.of<User>(context, listen: false).Rank = json['Rank'];
  Provider.of<User>(context, listen: false).Height = json['Height'];
  Provider.of<User>(context, listen: false).HandPreference =
      json['HandPreference'];
  Provider.of<User>(context, listen: false).Photo = json['Photo'];
}
