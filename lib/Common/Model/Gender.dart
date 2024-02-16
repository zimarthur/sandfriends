class Gender {
  final int idGender;
  final String name;

  Gender({
    required this.idGender,
    required this.name,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      idGender: json['IdGenderCategory'],
      name: json['GenderName'],
    );
  }
}
