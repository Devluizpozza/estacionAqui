import 'package:estacionaqui/app/services/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  final codeController = TextEditingController();
  late String verificationId;

  @override
  void initState() {
    super.initState();
    verificationId = Get.arguments;
  }

  void verifyCode() async {
    final code = codeController.text.trim();
    if (code.length == 6) {
      await AuthManager.to.verifyCode(verificationId, code);
    } else {
      Get.snackbar('Erro', 'Código inválido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verificação")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Digite o código enviado por SMS",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '000000',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyCode,
              child: const Text("Verificar"),
            ),
          ],
        ),
      ),
    );
  }
}
