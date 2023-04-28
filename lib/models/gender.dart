class Gender {
  final int idGender;
  final String name;

  Gender({
    required this.idGender,
    required this.name,
  });
}

Gender genderFromJson(Map<String, dynamic> json) {
  var newGender = Gender(
    idGender: json['IdGenderCategory'],
    name: json['GenderName'],
  );
  return newGender;
}
