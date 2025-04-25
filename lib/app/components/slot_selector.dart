import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SlotSelector extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const SlotSelector({
    super.key,
    this.initialValue = 1,
    required this.onChanged,
  });

  @override
  State<SlotSelector> createState() => _SlotSelectorState();
}

class _SlotSelectorState extends State<SlotSelector> {
  int value = 1;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue.clamp(1, 50);
  }

  void _updateValue(int delta) {
    setState(() {
      value = (value + delta).clamp(1, 50);
      widget.onChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _arrowButton(Icons.remove, () => _updateValue(-1)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$value',
              key: ValueKey(value),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          _arrowButton(Icons.add, () => _updateValue(1)),
        ],
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.lightBlue.withOpacity(0.2),
        ),
        child: Icon(icon, size: 30, color: AppColors.lightBlue),
      ),
    );
  }
}
