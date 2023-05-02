import 'package:sandfriends/oldApp/models/court_available_hours.dart';

import 'store.dart';

class Court {
  final int idStoreCourt;
  final String storeCourtName;
  final bool isIndoor;
  final Store store;
  List<CourtAvailableHours> availableHours = [];

  Court({
    required this.idStoreCourt,
    required this.storeCourtName,
    required this.isIndoor,
    required this.store,
  });
}

Court courtFromJson(Map<String, dynamic> json) {
  var newCourt = Court(
    idStoreCourt: json['IdStoreCourt'],
    storeCourtName: json['Description'],
    isIndoor: json['IsIndoor'],
    store: storeFromJson(
      json['Store'],
    ),
  );
  return newCourt;
}
