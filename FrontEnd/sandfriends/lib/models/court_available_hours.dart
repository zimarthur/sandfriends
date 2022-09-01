import '../models/court_price.dart';

class CourtAvailableHours {
  final int index;
  final String hour;
  final int hourIndex;
  List<CourtPrice> courtPrices;

  CourtAvailableHours(this.index, this.hour, this.hourIndex, this.courtPrices);

  int getCheapestCourt() {
    int cheapestCourt = courtPrices[0].price;
    for (int courtIndex = 0; courtIndex < courtPrices.length; courtIndex++) {
      if (courtPrices[courtIndex].price < cheapestCourt) {
        cheapestCourt = courtPrices[courtIndex].price;
      }
    }
    return cheapestCourt;
  }
}
