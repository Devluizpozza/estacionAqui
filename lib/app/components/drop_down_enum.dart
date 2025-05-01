import 'package:flutter/material.dart';

class DropDownEnum<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final Function(T?) onChanged;
  final List<T> values;
  final String Function(T) display;

  const DropDownEnum({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
    required this.values,
    required this.display,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButtonFormField<T>(
          value: selectedValue,
          isExpanded: true,
          items:
              values
                  .map(
                    (e) =>
                        DropdownMenuItem<T>(value: e, child: Text(display(e))),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
