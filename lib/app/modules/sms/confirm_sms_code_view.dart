import 'package:estacionaqui/app/modules/sms/confirm_sms_code_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmSmsCodeView extends GetView<ConfirmSmsCodeController> {
  const ConfirmSmsCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confirmar Código")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.codeController,
              decoration: InputDecoration(labelText: "Digite o código SMS"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.confirmCode,
              child: Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }
}
