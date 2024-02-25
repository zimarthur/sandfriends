extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String getRawNumber() {
    RegExp regex = RegExp(r'\d+');
    Iterable<Match> matches = regex.allMatches(this);

    StringBuffer buffer = StringBuffer();

    for (Match match in matches) {
      buffer.write(match.group(0));
    }

    return buffer.toString();
  }
}

extension DoubleExtension on double {
  String formatPrice({bool showRS = true}) {
    return "${showRS ? "R\$" : ""}${this.toStringAsFixed(2).replaceAll(".", ",")}";
  }
}
