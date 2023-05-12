import 'AvailableStore.dart';

class AvailableDay {
  DateTime day;
  List<AvailableStore> stores = [];

  AvailableDay({
    required this.day,
    required this.stores,
  });
}
