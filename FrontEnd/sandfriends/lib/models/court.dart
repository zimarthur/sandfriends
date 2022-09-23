import 'package:sandfriends/models/court_available_hours.dart';

class Court {
  final int idStoreCourt;
  final String storeCourtName;
  final bool isIndoor;
  List<CourtAvailableHours> availableHours = [];

  Court(this.idStoreCourt, this.storeCourtName, this.isIndoor);
}
