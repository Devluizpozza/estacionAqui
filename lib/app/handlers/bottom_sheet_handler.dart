import 'package:estacionaqui/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BottomSheetHandler {
  static showSimpleBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: child,
        );
      },
    );
  }

  static showCodeInputBottomSheet(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: AppColors.lightGrey,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Digite o código SMS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "Código",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.lightBlue,
                    ),
                  ),
                  child: Text("Confirmar"),
                ),
              ],
            ),
          ),
        );
      },

      isDismissible: false,
      enableDrag: false,
    );
  }
}
