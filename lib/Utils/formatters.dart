class Formatters {
  String formatPrice(dynamic value) {
    if (value == null) return "N/A";

    double price = 0.0;

    try {
      if (value is String) {
        // Remove commas before parsing
        value = value.replaceAll(",", "");
        price = double.parse(value);
      } else if (value is int || value is double) {
        price = value.toDouble();
      } else {
        return "N/A";
      }
    } catch (e) {
      return "N/A";
    }

    if (price >= 10000000) {
      return "₹${(price / 10000000).toStringAsFixed(2)} Cr";
    } else if (price >= 100000) {
      return "₹${(price / 100000).toStringAsFixed(2)} Lac";
    } else {
      return "₹${price.toStringAsFixed(0)}";
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
