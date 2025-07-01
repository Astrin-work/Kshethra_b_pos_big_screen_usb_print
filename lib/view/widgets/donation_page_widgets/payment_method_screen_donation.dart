import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kshethra_mini/view_model/donation_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kshethra_mini/utils/components/choose_payment_method_widget.dart';
import 'package:kshethra_mini/utils/components/app_bar_widget.dart';
import '../booking_page_widget/float_button_widget.dart';

class PaymentMethodScreenDonation extends StatefulWidget {
  final String? amount;
  final String? name;
  final String? phone;
  final String? acctHeadName;

  const PaymentMethodScreenDonation({
    super.key,
    this.amount,
    this.name,
    this.phone,
    this.acctHeadName,
  });

  @override
  State<PaymentMethodScreenDonation> createState() =>
      _PaymentMethodScreenDonationState();
}

class _PaymentMethodScreenDonationState
    extends State<PaymentMethodScreenDonation> {
  static const platform = MethodChannel('plutus_channel');

  String _selectedMethod = 'UPI';

  void _onMethodSelected(String method) {
    setState(() {
      _selectedMethod = method;
    });
  }

  Future<ui.Image> generateReceiptBitmap(String currentDate) async {
    const width = 576;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(width.toDouble(), 1000.0)));

    final textStyle = ui.TextStyle(color: Colors.black, fontSize: 22);
    final paragraphStyleCenter = ui.ParagraphStyle(textAlign: TextAlign.center);
    final paragraphStyleLeft = ui.ParagraphStyle(textAlign: TextAlign.left);

    // Header
    final header = ui.ParagraphBuilder(paragraphStyleCenter)
      ..pushStyle(ui.TextStyle(fontSize: 50.0, color: Colors.black))
      ..addText("Sample text");
    final headerParagraph = header.build()..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(headerParagraph, Offset(width / 2 - headerParagraph.width / 2, 40));

    double yOffset = 150.0;

    // Receipt No
    final receiptPara = ui.ParagraphBuilder(paragraphStyleLeft)
      ..pushStyle(textStyle)
      ..addText("Receipt No: 1234");
    final p1 = receiptPara.build()..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(p1, Offset(20, yOffset));
    yOffset += 35;

    // Date
    final datePara = ui.ParagraphBuilder(paragraphStyleLeft)
      ..pushStyle(textStyle)
      ..addText("Date: $currentDate");
    final p2 = datePara.build()..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(p2, Offset(20, yOffset));
    yOffset += 65;

    // Finalize image
    final picture = recorder.endRecording();
    final img = await picture.toImage(width, yOffset.toInt());
    return img;
  }

  Future<void> _printReceipt() async {
    try {
      final String currentDate = DateTime.now().toString().split(' ')[0];
      final image = await generateReceiptBitmap(currentDate);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception("Failed to convert image to byte data.");
      }

      final Uint8List byteArray = byteData.buffer.asUint8List();

      final String result = await platform.invokeMethod('printReceipt', {
        'image': byteArray,
      });

      print("Print result: $result");
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
    } catch (e) {
      print("Unknown error during print: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
          print("------clicked--------");
          _printReceipt();
      /*    final donationViewmodel = Provider.of<DonationViewmodel>(
            context,
            listen: false,
          );

          final amountStr = widget.amount;
          final name = widget.name ?? '';
          final phone = widget.phone ?? '';
          final acctHeadName = widget.acctHeadName ?? '';

          if (amountStr == null || int.tryParse(amountStr) == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid amount')),
            );
            return;
          }

          if (_selectedMethod == 'UPI') {
            donationViewmodel.navigateToQrScanner(
              context,
              amountStr,
              name: name,
              phone: phone,
              acctHeadName: acctHeadName,
            );*/

            // Call print after navigating or confirming

          // } else {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Unsupported payment method')),
          //   );
          // }
        },
      ),
    );
  }
}
