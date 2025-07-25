import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ReceiptFormatterEBhandaram {
  static const MethodChannel _platform = MethodChannel('com.example.panel_printer');

  static Future<void> printEBhandaramReceipt(
      BuildContext context, {
        required String name,
        required String star,
        required String amount,
        required String devathaName,
        required String receiptId,
        required String templeName,
        required String templeAddress,
        required String templePhone,
        required String receiptDate,
        required String receiptNumber,
      }) async {
    final image = await _generateReceiptImage(
      name: name,
      star: star,
      amount: amount,
      devathaName: devathaName,
      receiptId: receiptId,
      receiptDate: receiptDate,
      templeName: templeName,
      templeAddress: templeAddress,
      templePhone: templePhone,
      receiptNumber: receiptNumber,
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
    required String name,
    required String star,
    required String amount,
    required String devathaName,
    required String receiptId,
    required String receiptDate,
    required String templeName,
    required String templeAddress,
    required String templePhone,
    required String receiptNumber,
  }) async {
    const int width = 576;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(width.toDouble(), 2000)),
    );

    double yOffset = 20;

    void drawText(String text, double fontSize, {bool center = false, double indent = 20}) {
      final style = ui.ParagraphStyle(textAlign: center ? TextAlign.center : TextAlign.left);
      final builder = ui.ParagraphBuilder(style)
        ..pushStyle(ui.TextStyle(fontSize: fontSize, color: Colors.black))
        ..addText(text);
      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: width.toDouble()));
      canvas.drawParagraph(
        paragraph,
        Offset(center ? (width - paragraph.width) / 2 : indent, yOffset),
      );
      yOffset += paragraph.height + 8;
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

    void drawDashedLine() {
      final paint = Paint()
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

    // Header
    drawText(templeName.toUpperCase(), 30, center: true);
    drawText(templeAddress, 22, center: true);
    drawText("PH: $templePhone", 20, center: true);
    drawDashedLine();
    drawText("E-BHANDARAM RECEIPT", 26, center: true);
    drawDashedLine();


    drawLeftRightText("RECEIPT NO : $receiptNumber", "DATE : $receiptDate", 22);
    drawDashedLine();

    // Body
    drawText("NAME      : ${name.toUpperCase()}", 22);
    drawText("STAR      : ${star.toUpperCase()}", 22);
    drawText("DONATED DEVATHA : ${devathaName.toUpperCase()}", 22);
    drawText("AMOUNT    : ₹ $amount", 24);
    drawDashedLine();

    // Footer
    drawText("THANK YOU!", 22, center: true);

    final picture = recorder.endRecording();
    return picture.toImage(width, yOffset.toInt() + 40);
  }
}
