import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/choose_payment_method_widget.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'booking_page_widget/float_button_widget.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String? amount;
  const PaymentMethodScreen({super.key, this.amount});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = 'UPI';

  void _onMethodSelected(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
    final total = bookingViewmodel.combinedTotalAmount + bookingViewmodel.postalAmount;

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
        amount: total.toInt(),
        height: 60,
        title: 'Confirm',
        noOfScreens: 1,
        payOnTap: () {
          if (_selectedMethod == 'UPI') {
            bookingViewmodel.navigateToQrScanner(context);
            // bookingViewmodel.handleUpiPayment(total.toInt());
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
