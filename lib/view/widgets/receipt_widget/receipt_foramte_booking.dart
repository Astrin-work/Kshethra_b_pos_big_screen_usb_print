import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kshethra_mini/model/demo_model/temple_model.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';

class ReceiptFormatterBooking {
  static const MethodChannel _platform = MethodChannel(
    'com.example.panel_printer',
  );

  static Future<void> printGroupedReceipts(
      BuildContext context, {
        required List<Map<String, dynamic>> groupedReceipts,
        required String templeName,
        required String templeAddress,
        required String templePhone,
      }) async {
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final image = await _generateGroupedReceiptBitmap(
      currentDate: currentDate,
      groupedReceipts: groupedReceipts,
      templeName: templeName,
      templeAddress: templeAddress,
      templePhone: templePhone,
    );

    final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);
    final byteArray = byteData.buffer.asUint8List();

    try {
      final String result = await _platform.invokeMethod('printReceipt', {
        'image': byteArray,
      });
      print('🖨️ Print success: $result');
    } on PlatformException catch (e) {
      print("❌ Failed to print: '${e.message}'");
    }
  }

  static Future<ui.Image> _generateGroupedReceiptBitmap({
    required String currentDate,
    required List<Map<String, dynamic>> groupedReceipts,
    required String templeAddress,
    required String templeName,
    required String templePhone,
  }) async {
    const width = 576;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(width.toDouble(), 8000)),
    );

    final centerStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final leftStyle = ui.ParagraphStyle(textAlign: TextAlign.left);
    final rightStyle = ui.ParagraphStyle(textAlign: TextAlign.right);

    double yOffset = 20;

    void drawDashedLine({
      double dashWidth = 10,
      double dashSpace = 5,
      double thickness = 1,
      Color color = const Color(0xFF000000),
      double spaceAfter = 5,
    }) {
      final paint =
      Paint()
        ..color = color
        ..strokeWidth = thickness;

      double startX = 0;
      while (startX < width) {
        canvas.drawLine(
          Offset(startX, yOffset),
          Offset(startX + dashWidth, yOffset),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
      yOffset += thickness + spaceAfter;
    }

    void drawCentered(String text, double fontSize) {
      final builder =
      ui.ParagraphBuilder(centerStyle)
        ..pushStyle(
          ui.TextStyle(fontSize: fontSize, color: const Color(0xFF000000)),
        )
        ..addText(text);
      final paragraph =
      builder.build()
        ..layout(ui.ParagraphConstraints(width: width.toDouble()));
      canvas.drawParagraph(
        paragraph,
        Offset((width - paragraph.width) / 2, yOffset),
      );
      yOffset += paragraph.height + 5;
    }

    void drawLeft(String text, double fontSize, {double indent = 20}) {
      final builder =
      ui.ParagraphBuilder(leftStyle)
        ..pushStyle(
          ui.TextStyle(fontSize: fontSize, color: const Color(0xFF000000)),
        )
        ..addText(text);
      final paragraph =
      builder.build()
        ..layout(ui.ParagraphConstraints(width: width.toDouble()));
      canvas.drawParagraph(paragraph, Offset(indent, yOffset));
      yOffset += paragraph.height + 3;
    }

    void drawRight(String text, double fontSize, {double paddingRight = 20}) {
      final builder =
      ui.ParagraphBuilder(rightStyle)
        ..pushStyle(
          ui.TextStyle(fontSize: fontSize, color: const Color(0xFF000000)),
        )
        ..addText(text);
      final paragraph =
      builder.build()
        ..layout(ui.ParagraphConstraints(width: width.toDouble()));
      canvas.drawParagraph(
        paragraph,
        Offset(width - paragraph.longestLine - paddingRight, yOffset),
      );
      yOffset += paragraph.height + 3;
    }

    for (final group in groupedReceipts) {
      final serialNumber = group['serialNumber'] ?? '';
      final devatha = group['devatha'] ?? '';
      final items = group['receipts'] as List<dynamic>;
      double total = 0.0;

      // Header
      drawCentered(
        templeName.isNotEmpty ? templeName.toUpperCase() : "TEMPLE NAME",
        35,
      );
      // drawCentered("KSHETRAM", 28);
      drawCentered(
        templeAddress.isNotEmpty ? templeAddress : "TEMPLE ADDRESS",
        22,
      );
      drawCentered(
        templePhone.isNotEmpty ? "📞 $templePhone" : "📞 Temple Phone",
        20,
      );
      drawDashedLine();

      drawLeft(
        "RECEIPT NO : $serialNumber".padRight(40) +
            "DATE : $currentDate".padRight(15),
        22,
      );
      drawLeft("DEVATHA    : $devatha", 22);
      drawDashedLine(spaceAfter: 0);
      final headerLine =
      [
        "NO".padLeft(5),
        "VAZHIPADU".padLeft(15),
        "QTY".padLeft(20),
        "".padRight(2),
        "AMOUNT".padLeft(21),
      ].join();
      drawLeft(headerLine, 24, indent: 0);
      drawDashedLine(spaceAfter: 0);
      drawLeft('', 12);

      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final name = item['personName']?.toString().trim() ?? '';
        final star = item['personStar']?.toString().trim() ?? '';
        final itemName = item['offerName']?.toString().toUpperCase() ?? '';
        final qty = item['quantity'].toString();
        final rate = double.tryParse(item['rate'].toString()) ?? 0;
        final amount = (int.tryParse(qty) ?? 1) * rate;

        total += amount;


        const itemNameLineWidth = 40;
        const indent = 30;

        final itemNameLines = <String>[];
        for (int j = 0; j < itemName.length; j += itemNameLineWidth) {
          final end = (j + itemNameLineWidth < itemName.length)
              ? j + itemNameLineWidth
              : itemName.length;
          itemNameLines.add(itemName.substring(j, end));
        }


        drawLeft("${(i + 1).toString().padRight(3)}${itemNameLines[0]}", 22, indent: indent.toDouble());


        for (int j = 1; j < itemNameLines.length; j++) {
          drawLeft("   ${itemNameLines[j]}", 22, indent: indent.toDouble());
        }


        final qtyText = qty.padLeft(28);
        final amountText = "₹${amount.toStringAsFixed(2)}".padLeft(32);
        drawLeft("${" " * 30}$qtyText  $amountText", 22, indent: indent.toDouble());

        if (name.isNotEmpty || star.isNotEmpty) {
          final upperName = name.toUpperCase();
          final nameStarLine = star.isNotEmpty
              ? "$upperName (${star.toUpperCase()})"
              : upperName;
          drawLeft(nameStarLine.padLeft(28), 22);
        }

        yOffset += 5;
      }


      drawDashedLine();
      final label = "TOTAL".padRight(40); // adjust spacing as needed
      final amount = "₹${total.toStringAsFixed(2)}".padLeft(40); // pad full string including ₹

      drawLeft(label + amount, 24);


      yOffset += 20;
    }

    drawCentered("THANK YOU!", 22);
    drawCentered("HAVE A BLESSED DAY.", 20);

    final picture = recorder.endRecording();
    return picture.toImage(width, yOffset.toInt() + 40);
  }
}

