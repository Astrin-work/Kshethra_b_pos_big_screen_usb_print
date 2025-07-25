import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import '../app_color.dart';
import '../app_styles.dart';

class ChoosePaymentMethodWidget extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const ChoosePaymentMethodWidget({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    final fromLang = "en";
    final List<Map<String, dynamic>> paymentMethods = [
      {'label': 'Cash', 'icon': Icons.money},
      {'label': 'UPI', 'icon': Icons.qr_code},
      // {'label': 'Card', 'icon': Icons.credit_card},
    ];

    return Column(
      children:
      paymentMethods.map((method) {
        final isSelected = selectedMethod == method['label'];
        return GestureDetector(
          onTap: () {
            onMethodSelected(method['label']);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
              isSelected
                  ? kDullPrimaryColor.withOpacity(0.2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(method['icon'], color: kPrimaryColor, size: 28),
                const SizedBox(width: 15),
                BuildTextWidget(text: method['label'].toString().tr(), size: 15),
                const Spacer(),
                if (isSelected)
                  const Icon(Icons.check_circle, color: kPrimaryColor),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
