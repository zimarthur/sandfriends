import 'package:sandfriends/SharedComponents/Model/CreditCard/CardType.dart';
import 'package:sandfriends/SharedComponents/Model/CreditCard/CreditCard.dart';

CardType getCardTypeFrmNumber(String input) {
  CardType cardType;
  input = input.replaceAll(" ", "");
  if (input.startsWith(RegExp(
      r'636368|438935|504175|451416|509048|509067|509049|509069|509050|509074|509068|509040|509045|509051|509046|509066|509047|509042|509052|509043|509064|509040|36297|5067|4576|4011]'))) {
    cardType = CardType.Elo;
  } else if (input.startsWith(RegExp(r'38|60'))) {
    cardType = CardType.HiperCard;
  } else if (input.startsWith(RegExp(r'301|305|36|38'))) {
    cardType = CardType.DinersClub;
  } else if (input.startsWith(RegExp(r'34|37'))) {
    cardType = CardType.AmericanExpress;
  } else if (input.startsWith(RegExp(r'5'))) {
    cardType = CardType.Master;
  } else if (input.startsWith(RegExp(r'4'))) {
    cardType = CardType.Visa;
  } else if (input.length <= 8) {
    cardType = CardType.Others;
  } else {
    cardType = CardType.Invalid;
  }
  return cardType;
}

String creditCardImagePath(CardType cardType) {
  switch (cardType) {
    case CardType.Master:
      return r"assets\credit_card\mastercard.svg";
    case CardType.Visa:
      return r"assets\credit_card\visa.svg";
    case CardType.Elo:
      return r"assets\credit_card\elo.svg";
    case CardType.AmericanExpress:
      return r"assets\credit_card\amex.svg";
    case CardType.DinersClub:
      return r"assets\credit_card\diners.svg";
    case CardType.HiperCard:
      return r"assets\credit_card\hipercard.svg";

    default:
      return r"assets\credit_card\default_credit_card.svg";
  }
}

String encryptedCreditCardNumber(CreditCard card) {
  return "**** ${card.cardNumber.substring(card.cardNumber.length - 4)}";
}
