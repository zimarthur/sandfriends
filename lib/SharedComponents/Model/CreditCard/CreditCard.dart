import 'package:intl/intl.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CardType.dart';

class CreditCard {
  int idCreditCard;
  String cardNumber;
  int? cvv;
  DateTime expirationDate;
  String ownerName;
  String cpf;
  String? cardNickname;
  CardType cardType;

  CreditCard({
    required this.idCreditCard,
    required this.cardNumber,
    this.cvv,
    required this.expirationDate,
    required this.ownerName,
    required this.cpf,
    required this.cardNickname,
    required this.cardType,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      idCreditCard: json['IdUserCreditCard'],
      cardNumber: "**** ${json['CardNumber']}",
      cardNickname: json['Nickname'] == "" ? null : json['Nickname'],
      expirationDate: DateFormat('dd/MM/yyyy').parse(json['ExpirationDate']),
      ownerName: json['OwnerName'],
      cpf: json['OwnerCpf'],
      cardType: cardTypeFromString(json['CardType']),
    );
  }
}
