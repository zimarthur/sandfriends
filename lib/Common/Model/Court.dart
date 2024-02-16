import 'AvailableSport.dart';
import 'OperationDay.dart';
import 'Store.dart';

class Court {
  final int idStoreCourt;
  final String description;
  final bool isIndoor;
  Store? store;

  List<AvailableSport> sports = [];
  List<OperationDay> operationDays = [];

  Court({
    required this.idStoreCourt,
    required this.description,
    required this.isIndoor,
    this.store,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      idStoreCourt: json['IdStoreCourt'],
      description: json['Description'],
      isIndoor: json['IsIndoor'],
    );
  }

  factory Court.fromJsonMatch(Map<String, dynamic> json) {
    return Court(
      idStoreCourt: json['IdStoreCourt'],
      description: json['Description'],
      isIndoor: json['IsIndoor'],
      store: Store.fromJsonMatch(
        json['Store'],
      ),
    );
  }

  factory Court.copyWith(Court refCourt) {
    return Court(
      idStoreCourt: refCourt.idStoreCourt,
      description: refCourt.description,
      isIndoor: refCourt.isIndoor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Court == false) return false;
    Court otherCourt = other as Court;
    for (var avSport in sports) {
      if (avSport !=
          otherCourt.sports
              .firstWhere((sport) => sport.sport == avSport.sport)) {
        return false;
      }
    }
    //caso tenha adicionado um novo dia no jhorario de funcionamento, os horarios existentes podiam ser os mesmos, mas o len deles não
    if (operationDays.length != other.operationDays.length) {
      return false;
    }
    for (var operationDay in operationDays) {
      if (operationDay !=
          other.operationDays
              .firstWhere((opDay) => opDay.weekday == operationDay.weekday)) {
        return false;
      }
    }
    return description == otherCourt.description &&
        isIndoor == otherCourt.isIndoor;
  }

  @override
  int get hashCode => idStoreCourt.hashCode ^ description.hashCode;
}
