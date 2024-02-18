import 'Court.dart';
import 'Store/StoreComplete.dart';

class StoreDay {
  int? index;
  final Store store;
  final String? day;
  List<Court> courts = [];

  StoreDay({
    this.index,
    required this.store,
    this.day,
  });
}
