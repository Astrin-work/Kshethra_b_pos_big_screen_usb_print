import 'package:flutter/material.dart';
import 'package:kshethra_mini/view_model/donation_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/choose_payment_method_widget.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import '../booking_page_widget/float_button_widget.dart';

class PaymentMethodScreenDonation extends StatefulWidget {
  final String? amount;
  final String? name;
  final String? phone;
  final String? acctHeadName;

  const PaymentMethodScreenDonation({
    super.key,
    this.amount,
    this.name,
    this.phone,
    this.acctHeadName,
  });

  @override
  State<PaymentMethodScreenDonation> createState() =>
      _PaymentMethodScreenDonationState();
}

class _PaymentMethodScreenDonationState
    extends State<PaymentMethodScreenDonation> {
  String _selectedMethod = 'UPI';

  void _onMethodSelected(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarWidget(title: "Select Payment Method"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ChoosePaymentMethodWidget(
                selectedMethod: _selectedMethod,
                onMethodSelected: _onMethodSelected,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatButtonWidget(
        amount: int.tryParse(widget.amount ?? '0') ?? 0,
        height: 60,
        title: 'Confirm',
        noOfScreens: 1,
        payOnTap: () {
          final donationViewmodel = Provider.of<DonationViewmodel>(
            context,
            listen: false,
          );

          final amountStr = widget.amount;
          final name = widget.name ?? '';
          final phone = widget.phone ?? '';
          final acctHeadName = widget.acctHeadName ?? '';

          if (amountStr == null || int.tryParse(amountStr) == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid amount')),
            );
            return;
          }

          if (_selectedMethod == 'UPI') {
            donationViewmodel.navigateToQrScanner(
              context,
              amountStr,
              name: name,
              phone: phone,
              acctHeadName: acctHeadName,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unsupported payment method')),
            );
          }
        },

      ),
    );
  }
}
