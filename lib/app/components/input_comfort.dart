import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class InputComfort extends StatefulWidget {
  final List<String> comforts;
  final void Function(String) onChanged;

  const InputComfort({
    super.key,
    required this.comforts,
    required this.onChanged,
  });

  @override
  State<InputComfort> createState() => _InputComfortState();
}

class _InputComfortState extends State<InputComfort> {
  final TextEditingController _textController = TextEditingController();

  void _addComfort() {
    final text = _textController.text.trim();
    if (text.isNotEmpty && !widget.comforts.contains(text)) {
      setState(() {
        widget.comforts.add(text);
        _textController.clear();
      });
      widget.onChanged(text); // envia apenas a string nova
    }
  }

  void _removeComfort(String item) {
    setState(() {
      widget.comforts.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input com botão de envio dentro
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: _textController,
            onSubmitted: (_) => _addComfort(),
            decoration: InputDecoration(
              labelText: "Adicionar comodidade",
              labelStyle: TextStyle(color: Colors.blueGrey[200]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(Icons.send, color: AppColors.lightBlue),
                onPressed: _addComfort,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Chips dos itens já adicionados
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              widget.comforts.map((comfort) {
                return Chip(
                  label: Text(comfort),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeComfort(comfort),
                  backgroundColor: AppColors.lightBlue,
                  labelStyle: const TextStyle(color: Colors.black87),
                );
              }).toList(),
        ),
      ],
    );
  }
}
