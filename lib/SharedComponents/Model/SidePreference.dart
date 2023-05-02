class SidePreference {
  final int idSidePreference;
  final String name;

  SidePreference({
    required this.idSidePreference,
    required this.name,
  });

  factory SidePreference.fromJson(Map<String, dynamic> json) {
    return SidePreference(
      idSidePreference: json['IdSidePreferenceCategory'],
      name: json['SidePreferenceName'],
    );
  }
}
