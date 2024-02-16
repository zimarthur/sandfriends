import 'package:intl/intl.dart';

import '../AppMatch.dart';
import '../Hour.dart';
import '../Sport.dart';

class AppNotificationStore {
  int idNotification;
  String message;
  AppMatch match;
  DateTime eventTime;

  AppNotificationStore({
    required this.idNotification,
    required this.message,
    required this.match,
    required this.eventTime,
  });

  factory AppNotificationStore.fromJson(
    Map<String, dynamic> parsedJson,
    List<Hour> referenceHours,
    List<Sport> referenceSports,
  ) {
    return AppNotificationStore(
      idNotification: parsedJson["IdNotificationStore"],
      message: parsedJson["Message"],
      eventTime: DateFormat("dd/MM/yyyy HH:mm").parse(
        parsedJson["EventDatetime"],
      ),
      match: AppMatch.fromJson(
          parsedJson["Match"], referenceHours, referenceSports),
    );
  }
}
