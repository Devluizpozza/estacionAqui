import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Formatter {
  static final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'\d')},
  );

  static final displayNameInputFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-ZÀ-ÿ\s]+"),
  );

  static final emailInputFormatter = FilteringTextInputFormatter.deny(
    RegExp(r"\s"),
  );

  // >> FUNÇÕES DE FORMATAR TEXTO DIRETO:

  static String formatPhone(String phone) {
    final onlyDigits = phone.replaceAll(RegExp(r'[^\d]'), '');
    return phoneMask.maskText(onlyDigits);
  }

  static String formatName(String name) {
    // Remove espaços duplicados e corrige letras desnecessárias (bem simples)
    String cleanName = name.trim().replaceAll(RegExp(r'\s+'), ' ');
    return cleanName;
  }

  static String formatEmail(String email) {
    // Deixa o email tudo minúsculo e tira espaços
    return email.trim().toLowerCase();
  }
}
