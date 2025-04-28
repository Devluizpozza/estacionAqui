import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function()? onPressedSuffixIcon;
  final IconData? suffixIcon;
  final bool showSuffixIcon;
  final bool enabled;

  const InputText({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.showSuffixIcon = false,
    this.onPressedSuffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon:
              showSuffixIcon
                  ? IconButton(
                    icon: Icon(suffixIcon, color: AppColors.lightBlue),
                    onPressed: onPressedSuffixIcon,
                  )
                  : null,
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey[200]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        enabled: enabled,
      ),
    );
  }
}
