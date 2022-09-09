import 'package:sandfriends/models/court_available_hours.dart';

class Court {
  final int idStoreCourt;
  final String storeCourtName;
  List<CourtAvailableHours> availableHours = [];

  Court(this.idStoreCourt, this.storeCourtName);
}
