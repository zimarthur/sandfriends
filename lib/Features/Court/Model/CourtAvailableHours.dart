import '../../../SharedComponents/Model/Court.dart';
import 'HourPrice.dart';

class CourtAvailableHours {
  Court court;
  List<HourPrice> hourPrices;

  CourtAvailableHours({
    required this.court,
    required this.hourPrices,
  });
}
