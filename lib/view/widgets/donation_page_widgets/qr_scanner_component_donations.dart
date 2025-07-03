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
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScannerComponentDonations extends StatelessWidget {
  final String amount;
  final int noOfScreen;
  final String title;
  const QrScannerComponentDonations({
    super.key,
    required this.amount,
    required this.noOfScreen,
    required this.title,
    required String name,
    required String phone, required acctHeadName,
  });
  static const platform = MethodChannel('plutus_channel');

  // Future<ui.Image> generateReceiptBitmap(String currentDate) async {
  //   const width = 576;
  //   final recorder = ui.PictureRecorder();
  //   final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(width.toDouble(), 1000)));
  //
  //   final textStyle = ui.TextStyle(color: Colors.black, fontSize: 22);
  //   final paragraphStyleCenter = ui.ParagraphStyle(textAlign: TextAlign.center);
  //   final paragraphStyleLeft = ui.ParagraphStyle(textAlign: TextAlign.left);
  //
  //   // Header
  //   final header = ui.ParagraphBuilder(paragraphStyleCenter)
  //     ..pushStyle(ui.TextStyle(fontSize: 50.0, color: Colors.black))
  //     ..addText("Sample text");
  //   final headerParagraph = header.build()
  //     ..layout(ui.ParagraphConstraints(width: width.toDouble()));
  //   canvas.drawParagraph(headerParagraph, Offset((width - headerParagraph.width) / 2, 40));
  //
  //   double yOffset = 150.0;
  //
  //   // Receipt No
  //   final receiptPara = ui.ParagraphBuilder(paragraphStyleLeft)
  //     ..pushStyle(textStyle)
  //     ..addText("Receipt No: 1234");
  //   final p1 = receiptPara.build()
  //     ..layout(ui.ParagraphConstraints(width: width.toDouble()));
  //   canvas.drawParagraph(p1, Offset(20, yOffset));
  //   yOffset += 35;
  //
  //   // Date
  //   final datePara = ui.ParagraphBuilder(paragraphStyleLeft)
  //     ..pushStyle(textStyle)
  //     ..addText("Date: $currentDate");
  //   final p2 = datePara.build()
  //     ..layout(ui.ParagraphConstraints(width: width.toDouble()));
  //   canvas.drawParagraph(p2, Offset(20, yOffset));
  //   yOffset += 65;
  //
  //   final picture = recorder.endRecording();
  //   final img = await picture.toImage(width, yOffset.toInt());
  //   return img;
  // }
  //
  // Future<void> _print(BuildContext context) async {
  //   String currentDate = "2025-04-28";
  //   final image = await generateReceiptBitmap(currentDate);
  //
  //   final ByteData byteData =
  //       await image.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);
  //   final Uint8List byteArray = byteData.buffer.asUint8List();
  //
  //   try {
  //     final String result = await platform.invokeMethod('printReceipt', {
  //       'image': byteArray,
  //     });
  //     print(result);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Print successful")),
  //     );
  //   } on PlatformException catch (e) {
  //     print("Failed to print: '${e.message}'");
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to print: ${e.message}")),
  //     );
  //   }
  // }


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
                    text: "Amount ₹" "$amount",
                    color: kBlack,
                    size: 50,
                    fontWeight: FontWeight.w400,
                  ),
                  BuildTextWidget(
                    text:   "Scan this QR Code to pay",
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
                    child: Text("data"),
                    onPressed: () {
                      // await _print(context);

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
