import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReceiptFormateAdvBooking {
  static const MethodChannel _platform = MethodChannel(
    'com.example.panel_printer',
  );

  static Future<void> printGroupedReceipts(
    BuildContext context, {
    required List<Map<String, dynamic>> groupedReceipts,
    required String methodOption,
    required String repeatDay,
    required String templeName,
    required String templeAddress,
    required String templePhone,
  }) async {
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final image = await _generateGroupedReceiptBitmap(
      currentDate: currentDate,
      groupedReceipts: groupedReceipts,
      methodOption: methodOption,
      repeatDay: repeatDay,
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
    required String methodOption,
    required String repeatDay,
    required String templeAddress,
    required String templePhone,
    required String templeName,
  }) async {
    const width = 576;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(width.toDouble(), 8000)),
    );

    final centerStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final leftStyle = ui.ParagraphStyle(textAlign: TextAlign.left);
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

    String _capitalize(String text) {
      if (text.isEmpty) return text;
      return text[0].toUpperCase() + text.substring(1);
    }

    for (final group in groupedReceipts) {
      final serialNumber = group['serialNumber'] ?? '';
      final devatha = group['devatha'] ?? '';
      final postalCharge =
          double.tryParse(group['postalCharge']?.toString() ?? '0') ?? 0.0;
      final items = group['receipts'] as List<dynamic>;

      double total = 0.0;

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

      final headerLine = [
        "NO".padLeft(5),
        "VAZHIPADU".padLeft(15),
        "QTY".padLeft(29),
        "".padRight(2),
        "AMOUNT".padLeft(13  ),
      ].join();

      drawLeft(headerLine, 24, indent: 0);
      drawDashedLine(spaceAfter: 0);
      drawLeft('', 12);

      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final itemName = (item['offerName'] ?? '').toString().toUpperCase().trim();
        final qty = (item['quantity'] ?? '1').toString();
        final rate = double.tryParse(item['rate']?.toString() ?? '0') ?? 0.0;
        final itemTotal = rate * (int.tryParse(qty) ?? 1);
        final itemRepeatMethod = (item['repeatMethod'] ?? '').toString().toLowerCase();
        final totalFromApi = double.tryParse(group['totalAmount']?.toString() ?? '0') ?? 0.0;
        final itemRepeatDays = (item['repeatDays'] ?? '').toString();

        final displayRepeatDays = itemRepeatDays.isNotEmpty ? itemRepeatDays : repeatDay;
        final qtyWithRepeat = '$qty (${displayRepeatDays.toString()} Times)';

        // Split item name into multiple lines
        const itemNameLineWidth = 20;
        final nameLines = <String>[];
        for (int j = 0; j < itemName.length; j += itemNameLineWidth) {
          final end = (j + itemNameLineWidth < itemName.length)
              ? j + itemNameLineWidth
              : itemName.length;
          nameLines.add(itemName.substring(j, end));
        }

        final firstLine = [
          (i + 1).toString().padRight(4),
          nameLines[0].padRight(20),
          qtyWithRepeat.padLeft(18),
          "₹${itemTotal.toStringAsFixed(2)}".padLeft(12)
        ].join();

        drawLeft(firstLine, 22);

        // Additional item name lines
        for (int k = 1; k < nameLines.length; k++) {
          drawLeft("    ${nameLines[k]}", 22);
        }

        // Person details
        final personName = (item['personName'] ?? '').toString();
        final personStar = (item['personStar'] ?? '').toString();
        final rawName = '${personName.toUpperCase()}${personStar.isNotEmpty ? ' (${personStar.toUpperCase()})' : ''}';
        drawLeft("    $rawName", 22);

        // Repeat method
        final method = itemRepeatMethod.isNotEmpty ? itemRepeatMethod : methodOption.toLowerCase();
        final repeatLine = method == 'once' || method.isEmpty
            ? '    REPEAT : ONCE'
            : '    REPEAT : ${_capitalize(method).toUpperCase()}';
        drawLeft(repeatLine, 22);

        // Pooja Dates
        final poojaStartDate = (item['startDate'] ?? '').toString();
        final poojaEndDate = (item['endDate'] ?? '').toString();
        if (poojaStartDate.isNotEmpty && poojaEndDate.isNotEmpty) {
          drawLeft("    Pooja Date : $poojaStartDate to $poojaEndDate", 22);
        }

        // Devatha Name
        final devathaName = (item['devathaName'] ?? '').toString();
        if (devathaName.isNotEmpty) {
          drawLeft("    GOD: $devathaName", 22);
        }


      }

      final postalLabel = "POSTAL CHARGE:";
      final postalAmount = "₹${postalCharge.toStringAsFixed(2)}".padLeft(55);
      final postalLine = "   $postalLabel$postalAmount";
      drawLeft(postalLine, 22);

      drawLeft('', 22);
      drawDashedLine();
      final totalFromApi =
          double.tryParse(group['totalAmount']?.toString() ?? '0') ?? 0.0;
      final grandTotal = totalFromApi + postalCharge;
      drawLeft(
        "TOTAL".padRight(35) + "₹${grandTotal.toStringAsFixed(2)}".padLeft(41),
        24,
      );

      yOffset += 30;
    }

    drawCentered("THANK YOU!", 22);
    drawCentered("HAVE A BLESSED DAY.", 20);

    final picture = recorder.endRecording();
    return picture.toImage(width, yOffset.toInt() + 40);
  }
}
