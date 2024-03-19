class Infrastructure {
  int id;
  String description;
  bool isSelected;

  String get iconPath => "assets/icon/infrastructure/$id.svg";
  Infrastructure({
    required this.id,
    required this.description,
    this.isSelected = false,
  });

  factory Infrastructure.fromJson(Map<String, dynamic> json,
      {bool fromStoreInfrastructure = false}) {
    return Infrastructure(
      id: json['IdInfrastructureCategory'],
      description: json['Description'],
      isSelected: fromStoreInfrastructure,
    );
  }

  factory Infrastructure.copyFrom(Infrastructure refInfra, {bool? isSelected}) {
    return Infrastructure(
      id: refInfra.id,
      description: refInfra.description,
      isSelected: isSelected ?? refInfra.isSelected,
    );
  }
}
