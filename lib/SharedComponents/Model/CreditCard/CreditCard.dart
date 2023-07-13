class CreditCard {
  String cardNumber;
  int cvv;
  DateTime expirationDate;
  String ownerName;
  String cpf;
  String? cardNickname;

  CreditCard({
    required this.cardNumber,
    required this.cvv,
    required this.expirationDate,
    required this.ownerName,
    required this.cpf,
    required this.cardNickname,
  });
}
