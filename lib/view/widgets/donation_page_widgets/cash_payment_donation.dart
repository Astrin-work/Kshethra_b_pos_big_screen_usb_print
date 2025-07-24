import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/confirm_button_widget.dart';
import '../../../api_services/api_service.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/components/app_bar_widget.dart';
import '../../../utils/components/snack_bar_widget.dart';

class CashPaymentDonation extends StatelessWidget {
  final String? amount;
  final String? name;
  final String? phone;
  final String? acctHeadName;

  const CashPaymentDonation({
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
      "address":'',
      "paymentType": "Upi",
      "transactionId": "txn_${DateTime.now().millisecondsSinceEpoch}",
      "bankId": "CASH001",
      "bankName": "South Indian Bank",
    };

    try {
      await ApiService().postDonationDetails(donationData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(msg: "Donation posted successfully!", color: Colors.green).build(context),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(msg: "Failed to post donation: $e", color: Colors.red).build(context),
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
          AppBarWidget(title:"Cash_Payment".tr()),
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
            'give_amount_message'.tr(namedArgs: {'amount': amount.toString()}),
            style: styles.blackRegular20,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'confirm_after_receiving'.tr(),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      floatingActionButton: ConfirmButtonWidget(
        onConfirm: () async {
          final success = await postDonation(context);
          if (success && context.mounted) {
            _onConfirmPayment(context);
          }
        },
      ),


    );
  }
}
