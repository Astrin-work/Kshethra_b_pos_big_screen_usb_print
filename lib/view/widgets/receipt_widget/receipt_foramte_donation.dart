import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReceiptForamteDonation {
  static const MethodChannel _platform = MethodChannel(
    'com.example.panel_printer',
  );

  static Future<void> printDonationReceipt(
    BuildContext context, {
    required String templeName,
    required String templeAddress,
    required String templePhone,
    required String receiptNo,
    required String dateTime,
    required String name,
    required String phone,
    required String address,
    required String acctHead,
    required String amount,
    required date,
    required phoneNumber,
    required List groupedReceipts,
    required List postDonation,
  }) async {
    final image = await _generateReceiptImage(
      templeName: templeName,
      templeAddress: templeAddress,
      templePhone: templePhone,
      receiptNo: receiptNo,
      dateTime: date,
      name: name,
      phone: phone,
      address: address,
      acctHead: acctHead,
      amount: amount,
    );

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final byteArray = byteData.buffer.asUint8List();

    try {
      final result = await _platform.invokeMethod('printReceipt', {
        'image': byteArray,
      });
      print('🖨️ Print success: $result');
    } catch (e) {
      print("❌ Print error: $e");
    }
  }

  static Future<ui.Image> _generateReceiptImage({
    required String templeName,
    required String templeAddress,
    required String templePhone,
    required String receiptNo,
    required String dateTime,
    required String name,
    required String phone,
    required String address,
    required String acctHead,
    required String amount,
  }) async {
    const int width = 576;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(width.toDouble(), 2000)),
    );

    final centerStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final leftStyle = ui.ParagraphStyle(textAlign: TextAlign.left);

    double yOffset = 20;

    void drawText(
        String text,
        double fontSize, {
          bool center = false,
          double indent = 20,
        }) {
      final ui.ParagraphStyle style = ui.ParagraphStyle(
        textAlign: center ? TextAlign.center : TextAlign.left,
      );

      final builder = ui.ParagraphBuilder(style)
        ..pushStyle(ui.TextStyle(fontSize: fontSize, color: Colors.black))
        ..addText(text);

      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: width.toDouble())); // width = canvas width

      // Draw the paragraph
      canvas.drawParagraph(
        paragraph,
        Offset(center ? (width - paragraph.width) / 2 : indent, yOffset),
      );

      // Move the yOffset down for next line
      yOffset += paragraph.height + 6;
    }


    void drawDashedLine() {
      final paint =
          Paint()
            ..color = Colors.black
            ..strokeWidth = 1;
      double dashWidth = 10;
      double dashSpace = 5;
      double startX = 0;
      while (startX < width) {
        canvas.drawLine(
          Offset(startX, yOffset),
          Offset(startX + dashWidth, yOffset),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
      yOffset += 10;
    }
    void drawLeftRightText(String left, String right, double fontSize) {
      final textStyle = ui.TextStyle(fontSize: fontSize, color: Colors.black);

      final leftBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.left))
        ..pushStyle(textStyle)
        ..addText(left);
      final rightBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.right))
        ..pushStyle(textStyle)
        ..addText(right);

      final leftParagraph = leftBuilder.build()
        ..layout(ui.ParagraphConstraints(width: width.toDouble()));
      final rightParagraph = rightBuilder.build()
        ..layout(ui.ParagraphConstraints(width: width.toDouble()));

      canvas.drawParagraph(leftParagraph, Offset(20, yOffset));
      canvas.drawParagraph(rightParagraph, Offset(width - rightParagraph.width - 20, yOffset));

      yOffset += leftParagraph.height + 8;
    }
    // Temple Header
    drawText(templeName.toUpperCase(), 30, center: true);
    drawText(templeAddress, 22, center: true);
    drawText("PH: $templePhone", 20, center: true);
    drawDashedLine();

    // Receipt Heading
    drawText("DONATION RECEIPT", 24, center: true);
    drawDashedLine();
    drawLeftRightText("RECEIPT NO : $receiptNo", "DATE : $dateTime", 22);
    drawDashedLine();
    drawText("NAME         : $name".toUpperCase(), 22);
    drawText("DONATED VAZHIPADU: $acctHead", 22);
    drawText("DONATION AMT : ₹ $amount", 24);
    drawText("ADDRESS      : $address".toUpperCase(), 22);
    drawDashedLine();
    drawText("", 10);
    drawText("THANK YOU FOR YOUR GENEROUS SUPPORT!", 22, center: true);

    final picture = recorder.endRecording();
    return picture.toImage(width, yOffset.toInt() + 40);
  }
}
