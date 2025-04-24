extension StringExtension on String {
  bool equals(String? value) =>
      value != null && value.toLowerCase() == toLowerCase();
}
