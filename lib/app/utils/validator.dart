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

  static FormFieldValidator<String> emailValidator = (String? value) {
    if (value == null || value.isEmpty) return 'O campo é obrigatório';
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value)) return 'E-mail inválido';
    return null;
  };

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo é obrigatório';
    }
    final numbersOnly = value.replaceAll(RegExp(r'\D'), '');
    if (numbersOnly.length != 11) {
      return 'Telefone deve conter DDD + número com 9 dígitos';
    }
    if (!numbersOnly.substring(2).startsWith('9')) {
      return 'Número deve começar com 9 após o DDD';
    }

    return null;
  }

  static FormFieldValidator<String> plateValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Placa obrigatória';
    }
    final normalized = value.replaceAll('-', '').toUpperCase();
    final placaRegex = RegExp(r'^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$');
    if (!placaRegex.hasMatch(normalized)) {
      return 'Placa inválida (ex: ABC1234 ou ABC1D23)';
    }

    return null;
  };
}
