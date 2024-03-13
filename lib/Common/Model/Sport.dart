class Sport {
  final int idSport;
  final String description;
  final String photoUrl;

  Sport({
    required this.idSport,
    required this.description,
    required this.photoUrl,
  });

  String get iconLocation => "assets/icon/sport_icon_$idSport.svg";

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      idSport: json['IdSport'],
      description: json['Description'],
      photoUrl: json['SportPhoto'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Sport == false) return false;
    Sport otherSport = other as Sport;

    return idSport == otherSport.idSport;
  }

  @override
  int get hashCode => idSport.hashCode ^ description.hashCode;
}
