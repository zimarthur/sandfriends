enum CardType {
  Master,
  Visa,
  Elo,
  AmericanExpress,
  DinersClub,
  HiperCard,
  Others,
  Invalid
}

CardType cardTypeFromString(String rawCardType) {
  switch (rawCardType) {
    case "MASTER_CARD":
      return CardType.Master;
    case "VISA":
      return CardType.Visa;
    case "ELO":
      return CardType.Elo;
    case "AMERICAN_EXPRESS":
      return CardType.AmericanExpress;
    case "DINERS_CLUB":
      return CardType.DinersClub;
    case "HIPER_CARD":
      return CardType.HiperCard;
    default:
      return CardType.Others;
  }
}

String cardTypeToString(CardType cardType) {
  switch (cardType) {
    case CardType.Master:
      return "MASTER_CARD";
    case CardType.Visa:
      return "VISA";
    case CardType.Elo:
      return "ELO";
    case CardType.AmericanExpress:
      return "AMERICAN_EXPRESS";
    case CardType.DinersClub:
      return "DINERS_CLUB";
    case CardType.HiperCard:
      return "HIPER_CARD";
    default:
      return "OTHER";
  }
}
