import 'package:flutter/material.dart';
import 'package:kshethra_mini/view/widgets/e_hundi_page_widgets/choose_payment_method_e_hundi_widget.dart';
import 'package:kshethra_mini/view_model/donation_viewmodel.dart';
import 'package:kshethra_mini/view_model/e_hundi_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import '../../../utils/components/choose_payment_method_Widget.dart';
import '../booking_page_widget/float_button_widget.dart';

class PaymentMethodScreenEHundi extends StatefulWidget {
  final String? amount;
  final String? name;
  final String? phone;
  final String? acctHeadName;
  final String? devathaName;
  final String? star;
  const PaymentMethodScreenEHundi({
    super.key,
    this.amount,
    this.name,
    this.phone,
    this.acctHeadName, this.devathaName, this.star,
  });

  @override
  State<PaymentMethodScreenEHundi> createState() =>
      _PaymentMethodScreenState();
}
class _PaymentMethodScreenState extends State<PaymentMethodScreenEHundi> {
  String _selectedMethod = 'Cash';

  void _onMethodSelected(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }
@override
  void initState() {
    print("devatha Name:");
    print(widget.devathaName);
    print("star:");
    print(widget.star);
  }
  @override
  Widget build(BuildContext context) {
    final bookingViewmodel = Provider.of<BookingViewmodel>(
      context,
      listen: false,
    );

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
            final amount = widget.amount ?? '0';
            final name = widget.name ?? '';
            final phone = widget.phone ?? '';

            if (_selectedMethod == 'UPI') {
              print("Navigating to UPI QR Scanner with:");
              print("Amount: $amount, Name: $name, Phone: $phone");

              EHundiViewmodel().navigateToQrScanner(
                context,
                amount,
                name: name,
                phone: phone,
                DevathaName:widget.devathaName
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Unsupported payment method')),
              );
            }
          }

      ),
    );
  }
}
