class Sport {
  final int idSport;
  final String description;
  final String photoUrl;

  Sport({
    required this.idSport,
    required this.description,
    required this.photoUrl,
  });
}

Sport sportFromJson(Map<String, dynamic> json) {
  var newSport = Sport(
    idSport: json['IdSport'],
    description: json['Description'],
    photoUrl: json['SportPhoto'],
  );
  return newSport;
}
