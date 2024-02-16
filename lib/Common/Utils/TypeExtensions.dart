extension DoubleExtension on double {
  String formatPrice() {
    return "R\$${this.toStringAsFixed(2).replaceAll(".", ",")}";
  }
}
