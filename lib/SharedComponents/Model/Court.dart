import 'package:sandfriends/SharedComponents/Model/CourtAvailabeHour.dart';

class Court {
  final int idStoreCourt;
  final String storeCourtName;
  final bool isIndoor;
  List<CourtAvailableHour> availableHours = [];

  Court({
    required this.idStoreCourt,
    required this.storeCourtName,
    required this.isIndoor,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    var newCourt = Court(
      idStoreCourt: json['IdStoreCourt'],
      storeCourtName: json['Description'],
      isIndoor: json['IsIndoor'],
    );
    return newCourt;
  }
}
