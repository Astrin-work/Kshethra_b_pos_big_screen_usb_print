import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kshethra_mini/utils/app_color.dart';
import 'package:kshethra_mini/utils/app_styles.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import 'package:kshethra_mini/utils/components/size_config.dart';
import 'package:kshethra_mini/view/payment_complete_screen.dart';
import 'package:kshethra_mini/view/widgets/build_text_widget.dart';
import 'package:kshethra_mini/view/widgets/receipt_widget/receipt_formate_adv_booking.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../utils/logger.dart';
import '../receipt_widget/receipt_foramte_booking.dart';
import '../receipt_widget/receipt_printer.dart';

class QrScannerComponentAdvanceBooking extends StatelessWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  final String name;
  final String phone;
  final String acctHeadName;

  const QrScannerComponentAdvanceBooking({
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
    final bookingViewmodel = Provider.of<BookingViewmodel>(
      context,
      listen: false,
    );

    final temple =
        bookingViewmodel.templeList.isNotEmpty
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
    buffer.writeln(
      leftIndent + "No  Item Vazhipadu            Qty      Amount",
    );
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
    final bookingViewmodel = Provider.of<BookingViewmodel>(
      context,
      listen: false,
    );

    final temple =
        bookingViewmodel.templeList.isNotEmpty
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
    final statuses =
        await [
          Permission.bluetooth,
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
          Permission.location,
        ].request();
    return statuses.values.every((status) => status.isGranted);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = Provider.of<HomePageViewmodel>(context).currentLanguage;
    AppStyles styles = AppStyles();
    SizeConfig().init(context);

    return Scaffold(
      body: Consumer<HomePageViewmodel>(
        builder:
            (context, homepageViewmodel, child) => Column(
              children: [
                AppBarWidget(title: title.tr()),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.8,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BuildTextWidget(
                        text: 'amount_with_currency'.tr(
                          namedArgs: {'amount': amount.toString()},
                        ),
                        color: kBlack,
                        size: 50,
                        fontWeight: FontWeight.w400,
                      ),
                      BuildTextWidget(
                        text: 'scan_qr_to_pay'.tr(),
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
                            color: Colors.green,
                            textColor: Colors.white,
                            child: const Text("Adv booking print"),
                            onPressed: () async {
                              final viewmodel = context.read<BookingViewmodel>();

                              try {
                                final response = await viewmodel.submitAdvVazhipadu();

                                if (response.isEmpty) {
                                  throw Exception(" No receipt data found.");
                                }

                                final templeList = viewmodel.templeList;
                                String templeName = 'Temple Name';
                                String templeAddress = 'Temple Address';
                                String templePhone = 'Temple Phone';

                                if (templeList.isNotEmpty) {
                                  final lastTemple = templeList.last;
                                  templeName = lastTemple.templeName;
                                  templeAddress = lastTemple.address;
                                  templePhone = lastTemple.phoneNumber;
                                }

                                final Map<String, Map<String, dynamic>> groupedMap = {};

                                for (var item in response) {
                                  final serialNumber = (item['serialNumber'] ?? '').toString();
                                  final personName = (item['personName'] ?? '').toString();
                                  final personStar = (item['personStar'] ?? '').toString();
                                  final devathaName = (item['devathaName'] ?? '').toString();
                                  final offerName = (item['offerName'] ?? '').toString();
                                  final repeatMethod = (item['repeatMethod'] ?? '').toString();
                                  final repeatDays = (item['repeatDays'] ?? '').toString();
                                  final postalType = (item['postalType'] ?? '').toString();

                                  final quantity = int.tryParse((item['quantity'] ?? '1').toString()) ?? 1;
                                  final rate = (item['rate'] as num?)?.toDouble() ?? 0.0;

                                  final postalCharge = (() {
                                    final value = item['postalCharge'];
                                    if (value is String) return double.tryParse(value) ?? 0.0;
                                    if (value is int) return value.toDouble();
                                    if (value is double) return value;
                                    return 0.0;
                                  })();

                                  final totalAmount = (item['totalAmount'] as num?)?.toDouble() ?? 0.0;

                                  final poojaDateRaw = item['startDate'];
                                  final poojaDate = DateFormat('dd/MM/yyyy').format(
                                    DateTime.tryParse(poojaDateRaw.toString()) ?? DateTime.now(),
                                  );

                                  final receiptItem = {
                                    'personName': personName,
                                    'personStar': personStar,
                                    'offerName': offerName,
                                    'quantity': quantity,
                                    'rate': rate,
                                    'poojaDate': poojaDate,
                                  };

                                  if (!groupedMap.containsKey(serialNumber)) {
                                    groupedMap[serialNumber] = {
                                      'serialNumber': serialNumber,
                                      'devatha': devathaName,
                                      'postalCharge': postalCharge,
                                      'repeatMethod': repeatMethod,
                                      'repeatDays': repeatDays,
                                      'postalType': postalType,
                                      'totalAmount': totalAmount,
                                      'receipts': [receiptItem],
                                    };
                                  } else {
                                    (groupedMap[serialNumber]!['receipts'] as List).add(receiptItem);
                                  }
                                }

                                final printableReceipts = groupedMap.values.toList();


                                debugPrint("Printable Receipts:");
                                for (var receiptGroup in printableReceipts) {
                                  debugPrint(" Serial Number: ${receiptGroup['serialNumber']}");
                                  debugPrint(" Devatha: ${receiptGroup['devatha']}");
                                  debugPrint(" Postal Type: ${receiptGroup['postalType']}");
                                  debugPrint(" Postal Charge: ${receiptGroup['postalCharge']}");
                                  debugPrint(" Repeat Method: ${receiptGroup['repeatMethod']}");
                                  debugPrint("Repeat Days: ${receiptGroup['repeatDays']}");
                                  debugPrint(" Total Amount: ${receiptGroup['totalAmount']}");

                                  List receipts = receiptGroup['receipts'];
                                  for (var item in receipts) {
                                    debugPrint("     Person Name: ${item['personName']}");
                                    debugPrint("     Star: ${item['personStar']}");
                                    debugPrint("     Offer Name: ${item['offerName']}");
                                    debugPrint("     Quantity: ${item['quantity']}");
                                    debugPrint("     Rate: ${item['rate']}");
                                    debugPrint("     Pooja Date: ${item['poojaDate']}");
                                  }
                                  debugPrint("-----------------------------");
                                }

                                for (int i = 0; i < printableReceipts.length; i++) {
                                  print("🖨️ Printing receipt ${i + 1} of ${printableReceipts.length}");

                                  await ReceiptFormateAdvBooking.printGroupedReceipts(
                                    context,
                                    groupedReceipts: [printableReceipts[i]],
                                    methodOption: viewmodel.selectedRepMethod,
                                    repeatDay: viewmodel.repeatDays.toString(),
                                    templeName: templeName,
                                    templeAddress: templeAddress,
                                    templePhone: templePhone,
                                  );

                                  print(" Finished printing receipt ${i + 1}");
                                  await Future.delayed(const Duration(seconds: 2));
                                }



                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentCompleteScreen(
                                      amount: amount.toString(),
                                      noOfScreen: printableReceipts.length,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                debugPrint("❌ Error during print: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to print receipt. ${e.toString()}"),
                                  ),
                                );
                              }
                            },
                          ),


                        ],
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
