class SidePreference {
  final int idSidePreference;
  final String name;

  SidePreference({
    required this.idSidePreference,
    required this.name,
  });
}

SidePreference sidePreferenceFromJson(Map<String, dynamic> json) {
  var newSidePreference = SidePreference(
    idSidePreference: json['IdSidePreferenceCategory'],
    name: json['SidePreferenceName'],
  );
  return newSidePreference;
}
