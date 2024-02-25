class Hour {
  int hour;
  String hourString;

  Hour({
    required this.hour,
    required this.hourString,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      hour: json["IdAvailableHour"],
      hourString: json["HourString"],
    );
  }
}
