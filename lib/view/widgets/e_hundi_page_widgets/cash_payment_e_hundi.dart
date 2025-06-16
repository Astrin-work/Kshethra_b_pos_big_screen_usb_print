import 'package:flutter/material.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/confirm_button_widget.dart';
import '../../../api_services/api_service.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/components/app_bar_widget.dart';

class CashPaymentEHundi extends StatelessWidget {
  final String? amount;
  final String? name;
  final String? phone;
  final String? acctHeadName;

  const CashPaymentEHundi({
    super.key,
    this.amount,
    this.name,
    this.phone,
    this.acctHeadName,
  });

  Future<bool> postDonation(BuildContext context) async {
    print("---- Donation Details ----");
    print("Name: $name");
    print("Phone: $phone");
    print("Amount: $amount");
    print("Account Head Name: $acctHeadName");
    final donationData = {
      "name": name,
      "phoneNumber": phone,
      "acctHeadName": acctHeadName,
      "amount": amount,
      "paymentType": "Cash",
      "transactionId": "txn_${DateTime.now().millisecondsSinceEpoch}",
      "bankId": "CASH001",
      "bankName": "Cash Payment",
    };

    try {
      await ApiService().postDonationDetails(donationData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donation posted successfully!")),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post donation: $e")),
      );
      return false;
    }
  }

  void _onConfirmPayment(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentCompleteScreen(amount: amount.toString(), noOfScreen: 1),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppBarWidget(title: "Cash Payment"),
          const SizedBox(height: 80),
          Center(
            child: Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: kDullPrimaryColor, width: 5),
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/icons/donation.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Please give ₹$amount to our representative',
            style: styles.blackRegular20,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Confirm after receiving the full amount.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      floatingActionButton: ConfirmButtonWidget(
        onConfirm: () async {
          final success = await postDonation(context);
          if (success) {
            _onConfirmPayment(context);
          }
        },
      ),
    );
  }
}
