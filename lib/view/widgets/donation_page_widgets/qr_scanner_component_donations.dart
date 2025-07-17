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
import '../../../utils/logger.dart';

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

  Future<void> _printReceiptFromResponse(
      BuildContext context, {
        required String serialNumber,
        required List<Map<String, dynamic>> receipts,
      }) async {
    final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);

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
    const esc = '\x1B';
    const boldOn = '$esc\x45\x01';
    const boldOff = '$esc\x45\x00';
    const alignCenter = '$esc\x61\x01';
    const alignLeft = '$esc\x61\x00';
    const doubleFontOn = '$esc\x21\x30';
    const doubleFontOff = '$esc\x21\x00';
    const String leftIndent = '    ';

    final buffer = StringBuffer();
    double total = 0;
    final Set<String> printedNames = {};

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
    buffer.writeln(
      leftIndent +
          "Receipt No: $serialNumber   Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
    );

    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln(leftIndent + "No  Item Name            Qty    Amount");
    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));

    for (int i = 0; i < receipts.length; i++) {
      final r = receipts[i];
      final itemName = (r['offerName'] ?? 'Vazhipadu')
          .toString()
          .padRight(18)
          .substring(0, 18);
      final qty = r['quantity'].toString().padLeft(3);
      final rate = (r['rate'] as int?) ?? 0;
      final amt = rate * (r['quantity'] as int? ?? 1);
      total += amt;

      final personName = (r['personName'] ?? "-").toString().trim();
      final personStar = (r['personStar'] ?? "-").toString().trim();
      final nameKey = "$personName-$personStar";

      // Print vazhipadu row
      buffer.writeln(
        leftIndent +
            "${(i + 1).toString().padLeft(2)}. $itemName $qty   ₹${amt.toStringAsFixed(2).padLeft(7)}",
      );

      // Print name/star only if not already printed
      if (!printedNames.contains(nameKey)) {
        buffer.writeln(leftIndent + "    $personName ($personStar)");
        printedNames.add(nameKey);
        buffer.writeln(''); // Small spacing
      }
    }

    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln(
      leftIndent +
          "Total                       ₹${total.toStringAsFixed(2).padLeft(7)}",
    );
    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln('');
    buffer.write(alignCenter);
    buffer.write(boldOn);
    buffer.writeln("Thank you! Visit again");
    buffer.write(boldOff);
    buffer.writeln('\n\n\n');

    try {
      final result = await _platform.invokeMethod('printReceipt', {
        "text": buffer.toString(),
      });
      Logger.info("Print result: $result");
    } on PlatformException catch (e) {
      Logger.error("Print failed: ${e.message}");
      _showSnackBar(context, "Print failed: ${e.message}");
    }
  }


  Future<void> _printReceiptAdvFromResponse(
      BuildContext context, {
        required String serialNumber,
        required List<Map<String, dynamic>> receipts,
      }) async {
    final bookingViewmodel = Provider.of<BookingViewmodel>(context, listen: false);

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
    const esc = '\x1B';
    const boldOn = '$esc\x45\x01';
    const boldOff = '$esc\x45\x00';
    const alignCenter = '$esc\x61\x01';
    const alignLeft = '$esc\x61\x00';
    const doubleFontOn = '$esc\x21\x30';
    const doubleFontOff = '$esc\x21\x00';
    const String leftIndent = '    ';

    final buffer = StringBuffer();
    double total = 0;
    final Set<String> printedNames = {};

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
    buffer.writeln(
      leftIndent +
          "Receipt No: $serialNumber   Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
    );

    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln(leftIndent + "No  Item Name            Qty    Amount");
    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));

    for (int i = 0; i < receipts.length; i++) {
      final r = receipts[i];
      final itemName = (r['offerName'] ?? 'Vazhipadu')
          .toString()
          .padRight(18)
          .substring(0, 18);
      final qty = r['quantity'].toString().padLeft(3);
      final rate = (r['rate'] as int?) ?? 0;
      final amt = rate * (r['quantity'] as int? ?? 1);
      total += amt;

      final personName = (r['personName'] ?? "-").toString().trim();
      final personStar = (r['personStar'] ?? "-").toString().trim();
      final nameKey = "$personName-$personStar";

      // Print vazhipadu row
      buffer.writeln(
        leftIndent +
            "${(i + 1).toString().padLeft(2)}. $itemName $qty   ₹${amt.toStringAsFixed(2).padLeft(7)}",
      );

      // Print name/star only if not already printed
      if (!printedNames.contains(nameKey)) {
        buffer.writeln(leftIndent + "    $personName ($personStar)");
        printedNames.add(nameKey);
        buffer.writeln(''); // Small spacing
      }
    }

    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln(
      leftIndent +
          "Total                       ₹${total.toStringAsFixed(2).padLeft(7)}",
    );
    buffer.writeln(leftIndent + '-' * (lineWidth - leftIndent.length));
    buffer.writeln('');
    buffer.write(alignCenter);
    buffer.write(boldOn);
    buffer.writeln("Thank you! Visit again");
    buffer.write(boldOff);
    buffer.writeln('\n\n\n');

    try {
      final result = await _platform.invokeMethod('printReceipt', {
        "text": buffer.toString(),
      });
      Logger.info("Print result: $result");
    } on PlatformException catch (e) {
      Logger.error("Print failed: ${e.message}");
      _showSnackBar(context, "Print failed: ${e.message}");
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
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();
    return statuses.values.every((status) => status.isGranted);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: const Text("booking"),
                        onPressed: () async {
                          final viewmodel = context.read<BookingViewmodel>();
                          final response = await viewmodel.submitVazhipadu();
                          for (int index = 0; index < response.length; index++) {
                            final group = response[index];
                            final serial = group['serialNumber'];
                            final receiptList = group['receipts'] as List<dynamic>;

                            await _printReceiptFromResponse(
                              context,
                              serialNumber: serial.toString(),
                              receipts: receiptList.cast<Map<String, dynamic>>(),
                            );
                          }
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
                      MaterialButton(
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        child: const Text("advance"),
                        onPressed: () async {
                          final viewmodel = context.read<BookingViewmodel>();
                          final response = await viewmodel.submitVazhipadu();
                          for (int index = 0; index < response.length; index++) {
                            final group = response[index];
                            final serial = group['serialNumber'];
                            final receiptList = group['receipts'] as List<dynamic>;

                            await _printReceiptFromResponse(
                              context,
                              serialNumber: serial.toString(),
                              receipts: receiptList.cast<Map<String, dynamic>>(),
                            );
                          }
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
                      MaterialButton(
                        color: Colors.orangeAccent,
                        textColor: Colors.white,
                        child: const Text("donation"),
                        onPressed: () async {
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
                      MaterialButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        child: const Text("E-hundi"),
                        onPressed: () async {
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
