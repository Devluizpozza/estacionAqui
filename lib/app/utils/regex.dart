// ignore_for_file: non_constant_identifier_names

abstract class Regex {
  static only_digits(String input) => input.replaceAll(RegExp(r'\D'), '');
}
