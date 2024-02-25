class CnpjStore {
  String cnpj;
  String name;
  String cep;
  String state;
  String city;
  String neighborhood;
  String street;
  String number;

  CnpjStore({
    required this.cnpj,
    required this.name,
    required this.cep,
    required this.state,
    required this.city,
    required this.neighborhood,
    required this.street,
    required this.number,
  });

  factory CnpjStore.fromJson(Map<String, dynamic> json) {
    return CnpjStore(
      cnpj: json["cnpj"],
      name: json["nome_fantasia"],
      cep: json["cep"],
      state: json["uf"],
      city: json["municipio"],
      neighborhood: json["bairro"],
      street: "${json["descricao_tipo_de_logradouro"]} ${json["logradouro"]}",
      number: json["numero"],
    );
  }
}
