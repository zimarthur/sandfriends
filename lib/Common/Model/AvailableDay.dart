import 'AvailableStore.dart';

class AvailableDay {
  DateTime? day;
  int? weekday;
  List<AvailableStore> stores = [];

  AvailableDay({
    this.day,
    this.weekday,
    required this.stores,
  });
}
