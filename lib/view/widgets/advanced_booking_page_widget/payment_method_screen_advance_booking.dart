import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/choose_payment_method_widget.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';

import '../booking_page_widget/float_button_widget.dart';


class PaymentMethodScreenAdvanceBooking extends StatefulWidget {
  final String?amount;
  const PaymentMethodScreenAdvanceBooking({super.key,this.amount});

  @override
  State<PaymentMethodScreenAdvanceBooking> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreenAdvanceBooking> {
  String _selectedMethod = 'Cash';

  void _onMethodSelected(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
    final total = bookingViewmodel.combinedTotalAmount+bookingViewmodel.postalAmount;
    return Scaffold(
      body: Column(
        children: [
           AppBarWidget(title: "Select Payment Method".tr()),
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
          switch (_selectedMethod) {
            case 'UPI':
              bookingViewmodel.navigateToQrScanner(context);
              break;
            case 'Cash':
              bookingViewmodel.navigateToCashPaymentAdvanceBooking(context,total.toInt());
              break;
            case 'Card':
              bookingViewmodel.navigateCardScreen(context);
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Unsupported payment method')),
              );
          }
        },
      ),
    );
  }
}