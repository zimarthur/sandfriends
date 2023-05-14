import 'Store.dart';

class Court {
  final int idStoreCourt;
  final String storeCourtName;
  final bool isIndoor;
  Store? store;

  Court({
    required this.idStoreCourt,
    required this.storeCourtName,
    required this.isIndoor,
    this.store,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      idStoreCourt: json['IdStoreCourt'],
      storeCourtName: json['Description'],
      isIndoor: json['IsIndoor'],
    );
  }

  factory Court.fromJsonMatch(Map<String, dynamic> json) {
    return Court(
      idStoreCourt: json['IdStoreCourt'],
      storeCourtName: json['Description'],
      isIndoor: json['IsIndoor'],
      store: Store.fromJsonMatch(
        json['Store'],
      ),
    );
  }
}
