enum SelectedPayment { NotSelected, Pix, CreditCard, PayInStore }

SelectedPayment decoderSelectedPayment(String rawValue) {
  if (rawValue == "PIX") {
    return SelectedPayment.Pix;
  } else {
    return SelectedPayment.CreditCard;
  }
}
