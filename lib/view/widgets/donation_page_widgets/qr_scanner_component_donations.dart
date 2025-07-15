import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScannerComponentDonations extends StatelessWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  final String name;
  final String phone;
  final String acctHeadName;

  const QrScannerComponentDonations({
    super.key,
    required this.amount,
    required this.noOfScreen,
    required this.title,
    required this.name,
    required this.phone,
    required this.acctHeadName,
  });

  static const MethodChannel _platform = MethodChannel('printer_channel');

//   Future<void> _printReceipt(BuildContext context) async {
//     String message;
//
//     final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
//     final bookings = bookingViewmodel.vazhipaduBookingList;
//
//     if (bookings.isEmpty) {
//       _showSnackBar(context, "No vazhipadu data available.");
//       return;
//     }
//
//     final name = bookings.first.name ?? "-";
//     final phone = bookings.first.phno ?? "-";
//     final star = bookings.first.star ?? "-";
//
//     final temple = bookingViewmodel.templeList.isNotEmpty
//         ? bookingViewmodel.templeList.first
//         : null;
//
//     final templeName = temple?.templeName ?? "KSHEHTRA MINI TEMPLE";
//     final templeAddress = temple?.address ?? "Main Street, Calicut";
//     final templePhone = temple?.phoneNumber ?? "9876543210";
//
//     bool granted = await _requestBluetoothPermissions();
//     if (!granted) {
//       _showSnackBar(context, "Bluetooth permissions not granted.");
//       return;
//     }
//
//     const int lineWidth = 42;
//     final buffer = StringBuffer();
//     double total = 0.0;
//
//     // ESC/POS Control Codes
// // ESC/POS Control Codes
//     const esc = '\x1B';
//     const boldOn = '$esc\x45\x01';
//     const boldOff = '$esc\x45\x00';
//     const doubleFontOn = '$esc\x21\x30';
//     const doubleFontOff = '$esc\x21\x00';
//     const alignCenter = '$esc\x61\x01';
//     const alignLeft = '$esc\x61\x00';
//
// // Header
//     buffer.write(alignCenter);
//     buffer.write(boldOn); // smaller bold
//     buffer.writeln(templeName.toUpperCase());
//     buffer.write(boldOff);
//     buffer.writeln(templeAddress);
//     buffer.writeln(templePhone);
//     buffer.writeln('-' * lineWidth);
//
//
//     buffer.write(alignLeft);
//     buffer.writeln("Receipt No: CB-B-2   Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}");
//     buffer.writeln("Name     : $name");
//     buffer.writeln("Star     : $star");
//     buffer.writeln("Phone    : $phone");
//
//     buffer.writeln('-' * lineWidth);
//     buffer.writeln("No  Item Name            Qty    Amount");
//     buffer.writeln('-' * lineWidth);
//
//     for (int i = 0; i < bookings.length; i++) {
//       final item = bookings[i];
//       final itemName = (item.vazhipadu ?? '').padRight(18).substring(0, 18);
//       final qty = (item.count ?? '1').padLeft(3);
//       final amt = double.tryParse(item.totalPrice ?? '0') ?? 0.0;
//       total += amt;
//
//       buffer.writeln(
//         "${(i + 1).toString().padLeft(2)}. $itemName $qty   ₹${amt.toStringAsFixed(2).padLeft(7)}",
//       );
//     }
//
//     buffer.writeln('-' * lineWidth);
//     buffer.writeln("Total                       ₹${total.toStringAsFixed(2).padLeft(7)}");
//     buffer.writeln('-' * lineWidth);
//     buffer.writeln('');
//     buffer.write(alignCenter);
//     buffer.write(boldOn);
//     buffer.writeln("Thank you! Visit again");
//     buffer.write(boldOff);
//     buffer.writeln('\n\n\n');
//
//     try {
//       final result = await _platform.invokeMethod('printReceipt', {
//         "text": buffer.toString(),
//       });
//       message = "Print result: $result";
//     } on PlatformException catch (e) {
//       message = "Print failed: ${e.message}";
//     }
//
//     _showSnackBar(context, message);
//   }
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
  Future<void> _printReceipt(BuildContext context) async {
    String message;

    final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);
    final bookings = bookingViewmodel.vazhipaduBookingList;

    if (bookings.isEmpty) {
      _showSnackBar(context, "No vazhipadu data available.");
      return;
    }

    final name = bookings.first.name ?? "-";
    final phone = bookings.first.phno ?? "-";
    final star = bookings.first.star ?? "-";

    final temple = bookingViewmodel.templeList.isNotEmpty
        ? bookingViewmodel.templeList.first
        : null;

    final templeName = temple?.templeName ?? "KSHEHTRA MINI TEMPLE";
    final templeAddress = temple?.address ?? "Main Street, Calicut";
    final templePhone = temple?.phoneNumber ?? "9876543210";

    final splitName = splitTempleName(templeName);
    final line1 = splitName[0];
    final line2 = splitName[1];

    bool granted = await _requestBluetoothPermissions();
    if (!granted) {
      _showSnackBar(context, "Bluetooth permissions not granted.");
      return;
    }

    const int lineWidth = 42;
    final buffer = StringBuffer();
    double total = 0.0;

    // ESC/POS Control Codes
    const esc = '\x1B';
    const boldOn = '$esc\x45\x01';
    const boldOff = '$esc\x45\x00';
    const alignCenter = '$esc\x61\x01';
    const alignLeft = '$esc\x61\x00';
    const doubleFontOn = '$esc\x21\x30';
    const doubleFontOff = '$esc\x21\x00';

    const String leftIndent = '    '; // 4 spaces for right shift

    // Header
    buffer.write(alignCenter);
    buffer.write(boldOn);
    buffer.write(doubleFontOn);
    buffer.writeln(line1.toUpperCase());
    if (line2.isNotEmpty) buffer.writeln(line2.toUpperCase());
    buffer.write(doubleFontOff);
    buffer.write(boldOff);
    buffer.writeln(templeAddress);
    buffer.writeln(templePhone);
    buffer.writeln('-' * lineWidth);

    buffer.write(alignLeft);
    buffer.writeln(leftIndent + "Receipt No: CB-B-2   Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}");
    buffer.writeln(leftIndent + "Name     : $name");
    buffer.writeln(leftIndent + "Star     : $star");
    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));

    // Table Header
    buffer.writeln(leftIndent + "No  Item Name            Qty    Amount");
    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));

    for (int i = 0; i < bookings.length; i++) {
      final item = bookings[i];
      final itemName = (item.vazhipadu ?? '').padRight(18).substring(0, 18);
      final qty = (item.count ?? '1').padLeft(3);
      final amt = double.tryParse(item.totalPrice ?? '0') ?? 0.0;
      total += amt;

      buffer.writeln(
        leftIndent + "${(i + 1).toString().padLeft(2)}. $itemName $qty   ₹${amt.toStringAsFixed(2).padLeft(7)}",
      );
    }

    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln(leftIndent + "Total                       ₹${total.toStringAsFixed(2).padLeft(7)}");
    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln('');

    // Footer
    buffer.write(alignCenter);
    buffer.write(boldOn);
    buffer.writeln("Thank you! Visit again");
    buffer.write(boldOff);
    buffer.writeln('\n\n\n');

    try {
      final result = await _platform.invokeMethod('printReceipt', {
        "text": buffer.toString(),
      });
      message = "Print result: $result";
    } on PlatformException catch (e) {
      message = "Print failed: ${e.message}";
    }

    _showSnackBar(context, message);
  }






  Future<bool> _requestBluetoothPermissions() async {
    final bluetooth = await Permission.bluetooth.status;
    final connect = await Permission.bluetoothConnect.status;
    final scan = await Permission.bluetoothScan.status;
    final location = await Permission.location.status;

    if (bluetooth.isGranted &&
        connect.isGranted &&
        scan.isGranted &&
        location.isGranted) {
      return true;
    }

    final result = await [
      if (!bluetooth.isGranted) Permission.bluetooth,
      if (!connect.isGranted) Permission.bluetoothConnect,
      if (!scan.isGranted) Permission.bluetoothScan,
      if (!location.isGranted) Permission.location,
    ].request();

    return result.values.every((status) => status.isGranted);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder: (context, homepageViewmodel, child) => Column(
          children: [
            AppBarWidget(title: title.tr()),
            SizedBox(
              height: SizeConfig.screenHeight * 0.8,
              width: SizeConfig.screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildTextWidget(
                    text: "Amount ₹$amount",
                    color: kBlack,
                    size: 50,
                    fontWeight: FontWeight.w400,
                  ),
                  BuildTextWidget(
                    text: "Scan this QR Code to pay",
                    color: kBlack,
                    size: 18,
                    fontWeight: FontWeight.w300,
                    textAlign: TextAlign.center,
                  ),
                  QrImageView(
                    size: 300,
                    data: homepageViewmodel.setQrAmount(amount),
                  ),
                  Text("demotemple@okicici", style: styles.blackRegular13),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Text("Print"),
                    onPressed: () async {
                      await _printReceipt(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentCompleteScreen(
                            amount: amount,
                            noOfScreen: noOfScreen,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

