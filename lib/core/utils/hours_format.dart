/// Formata hores jugades (poden tenir mitges hores, p. ex. 12.5): sense
/// decimals quan són senceres, amb un sol decimal quan no ho són.
String formatHours(num hours) {
  if (hours == hours.roundToDouble()) {
    return hours.toInt().toString();
  }

  return hours.toStringAsFixed(1);
}
