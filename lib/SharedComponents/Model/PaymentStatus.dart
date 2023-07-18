enum PaymentStatus { Pending, Confirmed }

PaymentStatus decoderPaymentStatus(String rawValue) {
  if (rawValue == "PENDING") {
    return PaymentStatus.Pending;
  } else {
    return PaymentStatus.Confirmed;
  }
}
