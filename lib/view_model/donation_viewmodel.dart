import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/components/qr_code_component.dart';
import 'package:kshethra_mini/utils/components/snack_bar_widget.dart';
import 'package:kshethra_mini/view/widgets/donation_page_widgets/card_payment_donation_screen.dart';
import 'package:kshethra_mini/view/widgets/donation_page_widgets/cash_payment_donation.dart';
import 'package:kshethra_mini/view/widgets/donation_page_widgets/donation_dialogbox_widget.dart';
import 'package:kshethra_mini/view/widgets/donation_page_widgets/payment_method_screen_donation.dart';
import '../api_services/api_service.dart';
import '../services/plutus_smart.dart';
import '../utils/logger.dart';
import '../view/widgets/donation_page_widgets/qr_scanner_component_donations.dart';

class DonationViewmodel extends ChangeNotifier {
  final donationFormKey = GlobalKey<FormState>();
  final donationKey = GlobalKey<FormState>();

  TextEditingController donationAmountController = TextEditingController();
  TextEditingController donationNameController = TextEditingController();
  TextEditingController donationPhnoController = TextEditingController();

  void clearController() {
    donationAmountController.clear();
    donationNameController.clear();
  }

  void showDonationDialog(
    BuildContext context,
    String name,
    String phone,
    String acctHeadName,
      String address
  ) {
    bool valid = donationFormKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    clearDonationAmount();

    showDialog(
      context: context,
      builder:
          (context) => DonationDialogWidget(
            name: name,
            phone: phone,
            acctHeadName: acctHeadName, address: address,
          ),
    );
  }

  void popFunction(BuildContext context) {
    Navigator.pop(context);
  }

  void backtoHomePage(BuildContext context, int noOfPage) {
    for (int i = 1; i <= noOfPage; i++) {
      popFunction(context);
    }
  }

  String setQrAmount(String amount) {
    String value = "upi://pay?pa=6282488785@superyes&am=$amount&cu=INR";

    return value;
  }

  void clearDonationAmount() {
    donationAmountController.clear();
  }

  void navigateScannerPage(BuildContext context) {
    bool valid = donationKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }
    if (donationAmountController.text.trim() == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(msg: "Enter a Valid amount", color: kRed).build(context),
      );
      return;
    }
    popFunction(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponent(
              amount: donationAmountController.text.trim(),
              noOfScreen: 3,
              title: 'Donation',
            ),
      ),
    );
  }

  // Future<bool> postDonation(BuildContext context) async {
  //   final donationData = {
  //     "name": donationNameController.text.trim(),
  //     "phoneNumber": donationPhnoController.text.trim(),
  //     "acctHeadName": donationNameController.text.trim(),
  //     "amount": donationAmountController.text.trim(),
  //     "paymentType": "UPI",
  //     "transactionId": "txn_${DateTime.now().millisecondsSinceEpoch}",
  //     "bankId": "BANK001",
  //     "bankName": "Test Bank",
  //   };
  //
  //   try {
  //     await ApiService().postDonationDetails(donationData);
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Donation posted successfully!")));
  //     return true;
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Failed to post donation: $e")));
  //     return false;
  //   }
  // }

  void navigateToPaymentMethodPage(
    BuildContext context,
    String amount,
    String name,
    String phone,
    String acctHeadName,
      String address,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PaymentMethodScreenDonation(
              amount: amount,
              name: name,
              phone: phone,
              acctHeadName: acctHeadName,
              address:address
            ),
      ),
    );
  }

  void navigateToQrScanner(
    BuildContext context,
    String amount, {
    required String name,
    required String phone,
    required String acctHeadName,
        required String address,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerComponentDonations(
              name: name,
              phone: phone,
              amount: amount,
              address:address,
              acctHeadName: acctHeadName,
              noOfScreen: 1,
              title: "QR Scanner",
            ),
      ),
    );
  }

  void navigateToCashPayment(
    BuildContext context, {
    required String amount,
    required String name,
    required String phone,
    required String acctHeadName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CashPaymentDonation(
              amount: amount,
              name: name,
              phone: phone,
              acctHeadName: acctHeadName,
            ),
      ),
    );
  }

  void navigateCardScreen(
    context, {
    required String amount,
    required String name,
    required String phone,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CardPaymentDonationScreen()),
    );
  }

  Future<void> handleCardPayment(int amount) async {
    final payload = {
      "Header": {
        "ApplicationId": "f0d097be4df3441196d1e37cb2c98875",
        "MethodId": "1001",
        "UserId": "user1234",
        "VersionNo": "1.0",
      },
      "Detail": {
        "BillingRefNo": "TX98765432",
        "PaymentAmount": amount,
        "TransactionType": 4001,
      },
    };
    final transactionDataJson = jsonEncode(payload);
    Logger.info("Card Sending: $transactionDataJson");

    try {
      Logger.info("-----------Card payment initiated-----------");
      final result = await PlutusSmart.startTransaction(transactionDataJson);
      Logger.info("CARD TRANSACTION RESULT: $result");
    } catch (e) {
      Logger.error("Card Transaction failed: $e");
    }
  }

  Future<void> handleUpiPayment(int amount) async {
    final payload = {
      "Header": {
        "ApplicationId": "f0d097be4df3441196d1e37cb2c98875",
        "MethodId": "1001",
        "UserId": "user1234",
        "VersionNo": "1.0",
      },
      "Detail": {
        "BillingRefNo": "TX98765432",
        "PaymentAmount": amount,
        "TransactionType": 5120,
      },
    };
    final transactionDataJson = jsonEncode(payload);
    Logger.info("UPI Sending: $transactionDataJson");

    try {
      Logger.info("-----------UPI payment initiated-----------");
      final result = await PlutusSmart.startTransaction(transactionDataJson);
      Logger.info("UPI TRANSACTION RESULT: $result");
    } catch (e) {
      Logger.error("UPI Transaction failed: $e");
    }
  }

  Future<bool> postDonation(
    BuildContext context,
    String amount,
    String name,
    String phone,
    String acctHeadName,
  ) async {
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
      "address": '',
      "paymentType": "Cash",
      "transactionId": "txn_${DateTime.now().millisecondsSinceEpoch}",
      "bankId": "CASH001",
      "bankName": "Cash Payment",
    };

    try {
      final response = await ApiService().postDonationDetails(donationData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Donation posted successfully!",
          color: Colors.green,
        ).build(context),
      );

      // Optional: trigger receipt print here
      // await ReceiptForamteDonation.printDonationReceipt(...);

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarWidget(
          msg: "Failed to post donation: $e",
          color: Colors.red,
        ).build(context),
      );
      return false;
    }
  }
}
