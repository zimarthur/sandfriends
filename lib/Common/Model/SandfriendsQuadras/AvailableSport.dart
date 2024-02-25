import '../Sport.dart';

class AvailableSport {
  Sport sport;
  bool isAvailable;

  AvailableSport({
    required this.sport,
    required this.isAvailable,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is AvailableSport == false) return false;
    AvailableSport otherSport = other as AvailableSport;

    return sport == otherSport.sport && isAvailable == other.isAvailable;
  }

  @override
  int get hashCode => sport.hashCode ^ isAvailable.hashCode;

  factory AvailableSport.copyFrom(AvailableSport refAvSport) {
    return AvailableSport(
      sport: refAvSport.sport,
      isAvailable: refAvSport.isAvailable,
    );
  }
}
