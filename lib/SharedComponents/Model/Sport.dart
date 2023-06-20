import '../../Remote/Url.dart';

class Sport {
  final int idSport;
  final String description;
  final String photoUrl;

  Sport({
    required this.idSport,
    required this.description,
    required this.photoUrl,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      idSport: json['IdSport'],
      description: json['Description'],
      photoUrl: sandfriendsRequestsUrl + json['SportPhoto'],
    );
  }
}
