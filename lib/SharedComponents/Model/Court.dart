import 'package:sandfriends/SharedComponents/Model/CourtAvailabeHour.dart';

import 'Store.dart';

class Court {
  final int idStoreCourt;
  final String storeCourtName;
  final bool isIndoor;
  final Store store;
  List<CourtAvailableHour> availableHours = [];

  Court({
    required this.idStoreCourt,
    required this.storeCourtName,
    required this.isIndoor,
    required this.store,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    var newCourt = Court(
      idStoreCourt: json['IdStoreCourt'],
      storeCourtName: json['Description'],
      isIndoor: json['IsIndoor'],
      store: Store.fromJson(
        json['Store'],
      ),
    );
    return newCourt;
  }
}
