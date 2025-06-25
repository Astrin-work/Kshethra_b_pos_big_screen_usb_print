import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/confirm_button_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:kshethra_mini/view_model/terminal_viewmodel.dart';
import 'package:provider/provider.dart';
import '../services/plutus_smart.dart';
import '../utils/app_color.dart';
import '../utils/app_styles.dart';
import '../utils/components/app_bar_widget.dart';
import '../utils/logger.dart';

class CashPayment extends StatelessWidget {
  final int amount;
  const CashPayment({super.key, required this.amount});

  void _onConfirmPayment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cash payment confirmed."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
            PaymentCompleteScreen(amount: amount.toString(), noOfScreen: 1),
      ),
      // (route) => false,
    );
  }

  Future<void> _handlePrint(TerminalViewmodel provider) async {
    try {
      provider.addStatusMessage("INITIATING PRINT JOB.");
      Logger.info('INITIATING PRINT JOB.');

      // Get the print data from the provider
      final printData = provider.printData;
      final printDataJson = jsonEncode(printData);

      // Call the print job method
      final result = await PlutusSmart.startPrintJob(printDataJson);

      // Log the result
      provider.addStatusMessage("PRINT JOB RESULT: $result");
      Logger.info('PRINT JOB RESULT: $result');
    } catch (e) {
      provider.addStatusMessage("PRINT JOB ERROR: $e");
      Logger.error('PRINT JOB ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();
    final bookingViewmodel = Provider.of<BookingViewmodel>(
      context,
      listen: false,
    );
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
          final viewmodel = context.read<BookingViewmodel>();
          print("--------------temple name------------");
          await viewmodel.fetchTempleData();
          final response = await viewmodel.submitVazhipadu();

          try {
            final bindResult = await PlutusSmart.bindToService();
            Logger.info("Service Bind Result: $bindResult");

            if (bindResult != "SUCCESS") {
              Logger.error("Failed to bind to service. Aborting transaction.");
              return;
            }
          } catch (e) {
            Logger.error("Service bind error: $e");
            return;
          }

          for (int index = 0; index < response.length; index++) {
            final group = response[index];

            // await PrintService.printReceipt(
            //   serialNumber: '${group['serialNumber']}',
            //   receipts: List<Map<String, dynamic>>.from(group['receipts']),
            //   temples: bookingViewmodel.templeList,
            //   index: index,
            //
            // );

              //
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
                }
              };

              //
              final transactionDataJson = jsonEncode(payload);
              Logger.info("Sending: $transactionDataJson");

              try {
                print("-----------payment working-----------");
                final result = await PlutusSmart.startTransaction(transactionDataJson);
                Logger.info("TRANSACTION RESULT: $result");
              } catch (e) {
                Logger.error("Transaction failed: $e");
                return;
              }
          }
          // _handlePrint(TerminalViewmodel());

          _onConfirmPayment(context);
        },
      ),
    );
  }
}