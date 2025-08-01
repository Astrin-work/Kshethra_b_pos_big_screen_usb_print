import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/advanced_booking_page_widget/confirm_button_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/components/app_bar_widget.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../../view_model/booking_viewmodel.dart';
import '../receipt_widget/receipt_printer.dart';


class CashPaymentAdvanceBooking extends StatelessWidget {
  final int amount;
  const CashPaymentAdvanceBooking({super.key, required this.amount});

  static const MethodChannel _platform = MethodChannel('com.example.panel_printer');

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
        builder: (context) => PaymentCompleteScreen(
          amount: amount.toString(),
          noOfScreen: 1,
        ),
      ),
    );
  }

  Future<void> _printReceipt() async {
    try {
      final String result = await _platform.invokeMethod('printReceipt');
      print(result); // You can show a snackbar or dialog if you want
    } on PlatformException catch (e) {
      print("Failed to print: '${e.message}'");
    }
  }

  List<String> splitTempleName(String name, {int maxLineLength = 20}) {
    final words = name.trim().split(RegExp(r'\s+'));
    String line1 = '';
    String line2 = '';

    for (final word in words) {
      if ((line1 + ' ' + word).trim().length <= maxLineLength) {
        line1 = (line1 + ' ' + word).trim();
      } else {
        line2 = (line2 + ' ' + word).trim();
      }
    }

    return [line1, line2];
  }

  Future<bool> _requestBluetoothPermissions() async {
    final permissions = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    return permissions.values.every((status) => status.isGranted);
  }

  // Future<void> _printReceiptFromResponse(
  //     BuildContext context, {
  //       required String serialNumber,
  //       required List<Map<String, dynamic>> receipts,
  //     }) async {
  //   final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
  //
  //   final temple = bookingViewmodel.templeList.isNotEmpty
  //       ? bookingViewmodel.templeList.first
  //       : null;
  //
  //   final templeName = temple?.templeName ?? "KSHEHTRA MINI TEMPLE";
  //   final templeAddress = temple?.address ?? "Main Street, Calicut";
  //   final templePhone = temple?.phoneNumber ?? "9876543210";
  //
  //   final splitName = splitTempleName(templeName);
  //   final line1 = splitName[0];
  //   final line2 = splitName[1];
  //
  //   bool granted = await _requestBluetoothPermissions();
  //   if (!granted) {
  //     _showSnackBar(context, "Bluetooth permissions not granted.");
  //     return;
  //   }
  //
  //   const int lineWidth = 42;
  //   const esc = '\x1B';
  //   const boldOn = '$esc\x45\x01';
  //   const boldOff = '$esc\x45\x00';
  //   const alignCenter = '$esc\x61\x01';
  //   const alignLeft = '$esc\x61\x00';
  //   const doubleFontOn = '$esc\x21\x30';
  //   const doubleFontOff = '$esc\x21\x40';
  //   const mediumFont = '$esc\x21\x00';
  //   const String leftIndent = '    ';
  //
  //
  //
  //
  //   final buffer = StringBuffer();
  //   double total = 0;
  //   final Set<String> printedNames = {};
  //
  //   buffer.write(alignCenter);
  //   buffer.write(boldOn);
  //   buffer.write(doubleFontOn);
  //
  //   if (line2.isNotEmpty) {
  //     buffer.writeln(line1.trim().toUpperCase());
  //     buffer.writeln(line2.trim().toUpperCase());
  //   } else {
  //     buffer.writeln(line1.trim().toUpperCase());
  //   }
  //
  //   buffer.write(doubleFontOff);
  //   buffer.write(boldOff);
  //   buffer.writeln(templeAddress.trim());
  //   buffer.writeln(templePhone.trim());
  //   buffer.writeln('-' * lineWidth);
  //   buffer.write(alignLeft);
  //   buffer.write(mediumFont);
  //   buffer.write(boldOn);
  //   buffer.writeln(
  //     leftIndent +
  //         "Receipt No: $serialNumber           Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
  //   );
  //
  //   final devathaName = bookingViewmodel.selectedGods?.devathaName.trim() ?? "N/A";
  //   buffer.writeln(leftIndent + "Devatha: $devathaName");
  //   buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
  //   buffer.writeln(leftIndent + "No  Item Name            Qty    Amount");
  //   buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
  //
  //   for (int i = 0; i < receipts.length; i++) {
  //     final r = receipts[i];
  //     final itemName = (r['offerName'] ?? 'Vazhipadu')
  //         .toString()
  //         .padRight(18)
  //         .substring(0, 18);
  //     final qty = r['quantity'].toString().padLeft(3);
  //     final rate = (r['rate'] as int?) ?? 0;
  //     final amt = rate * (r['quantity'] as int? ?? 1);
  //     total += amt;
  //
  //     final personName = (r['personName'] ?? "-").toString().trim();
  //     final personStar = (r['personStar'] ?? "-").toString().trim();
  //     final nameKey = "$personName-$personStar";
  //
  //     buffer.writeln(
  //       leftIndent +
  //           "${(i + 1).toString().padLeft(2)}. $itemName $qty   ₹${amt.toStringAsFixed(2).padLeft(7)}",
  //     );
  //
  //     if (!printedNames.contains(nameKey)) {
  //       buffer.writeln(leftIndent + "    $personName ($personStar)");
  //       printedNames.add(nameKey);
  //       buffer.writeln();
  //     }
  //   }
  //
  //   buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
  //   buffer.writeln(
  //     leftIndent +
  //         "Total                       ₹${total.toStringAsFixed(2).padLeft(7)}",
  //   );
  //   buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
  //   buffer.writeln();
  //   buffer.write(boldOff);
  //   buffer.write(doubleFontOff);
  //   buffer.write(alignCenter);
  //   buffer.write(boldOn);
  //   buffer.writeln("Thank you! Visit again");
  //   buffer.write(boldOff);
  //   buffer.writeln('\n\n\n');
  //
  //
  //   try {
  //     final result = await _platform.invokeMethod('printReceipt', {
  //       "text": buffer.toString(),
  //     });
  //     Logger.info("Print result: $result");
  //   } on PlatformException catch (e) {
  //     Logger.error("Print failed: ${e.message}");
  //     _showSnackBar(context, "Print failed: ${e.message}");
  //   }
  // }
  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
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
          final viewmodel = context.read<BookingViewmodel>();

          // 🌐 Fetch temple details
          final temple = viewmodel.templeList.isNotEmpty
              ? viewmodel.templeList.first
              : null;

          final templeName = temple?.templeName ?? "KSHEHTRA MINI TEMPLE";
          final templeAddress = temple?.address ?? "Main Street, Calicut";
          final templePhone = temple?.phoneNumber ?? "9876543210";

          // 🧾 Split temple name into 2 lines
          final splitName = splitTempleName(templeName);
          final line1 = splitName[0];
          final line2 = splitName[1];

          try {
            // ✅ Step 1: Submit the advance booking
            final response = await viewmodel.submitAdvVazhipadu();

            if (response.isEmpty) {
              throw Exception("❌ No receipt data found.");
            }

            // ✅ Step 2: Loop through each receipt group and print
            for (final item in response) {
              final serialNumber = item['serialNumber'] ?? '';
              final name = item['personName'] ?? '';
              final star = item['personStar'] ?? '';
              final poojaDate = DateFormat('dd/MM/yyyy').format(
                DateTime.tryParse(item['startDate'] ?? '') ?? DateTime.now(),
              );
              final postalCharge = (item['postalCharge'] ?? 0.0).toStringAsFixed(2);

              final receiptList = item['receipts'] as List<dynamic>? ?? [];

              final items = receiptList.map((entry) {
                return {
                  'name': entry['offerName'] ?? '',
                  'quantity': entry['quantity']?.toString() ?? '1',
                  'god': entry['devathaName'] ?? '',
                  'repeat': entry['repeatType'] ?? '',
                  'amount': (entry['rate'] ?? 0.0).toStringAsFixed(2),
                };
              }).toList();

              await ReceiptPrinter.printReceipt(
                serialNumber: serialNumber,
                name: name,
                star: star,
                poojaDate: poojaDate,
                postalCharge: postalCharge,
                items: items,
              );
            }

            // ✅ Step 3: Navigate or complete confirmation
            _onConfirmPayment(context);
          } catch (e) {
            debugPrint("❌ Error during print: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to print receipt. ${e.toString()}")),
            );
          }
        },
      ),




    );
  }
}
