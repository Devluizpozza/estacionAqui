import 'package:flutter/material.dart';

abstract class Validator {
  static FormFieldValidator<String> displayNameValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome obrigatório';
    }
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return 'Use apenas letras e espaços';
    }
    return null;
  };

  static FormFieldValidator<String> emailValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email obrigatório';
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%-]+@(gmail\.com|hotmail\.com|outlook\.com|yahoo\.com|live\.com|icloud\.com|protonmail\.com|[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$",
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  };
}
