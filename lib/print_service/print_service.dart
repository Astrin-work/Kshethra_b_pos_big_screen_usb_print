import 'dart:convert';
import '../model/api models/get_temple_model.dart';
import '../services/plutus_smart.dart';
import '../utils/logger.dart';

class PrintService {
  static Future<void> printReceipt({
    required String serialNumber,
    required List<Map<String, dynamic>> receipts,
    required List<GetTemplemodel> temples,
    required int index,
  }) async {
    try {
      final currentTemple = temples[index];
      final receiptDate = _formattedDate();
      final timeNow = _formattedTime();

      final formattedLines = buildTempleReceiptPrintData(
        currentTemple: currentTemple,
        receipts: receipts,
        receiptNo: serialNumber,
        receiptDate: receiptDate,
        receiptTime: timeNow,
      );

      final printData = {
        "Header": {
          "ApplicationId": "f0d097be4df3441196d1e37cb2c98875",
          "UserId": "user1234",
          "MethodId": "1002",
          "VersionNo": "1.0",
        },
        "Detail": {
          "PrintRefNo": serialNumber,
          "SavePrintData": false,
          "Data": formattedLines,
        },
      };

      final printDataJson = jsonEncode(printData);

      Logger.info('🖨️ Binding to Plutus service...');
      final bindResult = await PlutusSmart.bindToService();

      if (bindResult == "SUCCESS" || bindResult == "BINDING SUCCESS.") {
        Logger.success("Service bound successfully.");
        final result = await PlutusSmart.startPrintJob(printDataJson);
        Logger.success("🧾 Print result: $result");
      } else {
        Logger.error("Binding failed: $bindResult");
      }
    } catch (e) {
      Logger.error("Exception during printing: ${e.toString()}");
    }
  }

  static List<Map<String, dynamic>> buildTempleReceiptPrintData({
    required GetTemplemodel currentTemple,
    required List<Map<String, dynamic>> receipts,
    required String receiptNo,
    required String receiptDate,
    required String receiptTime,
  }) {
    int totalAmount = 0;

    final List<Map<String, dynamic>> lines = [
      _printLine(currentTemple.templeName, fontSize: 2),
      _printLine(currentTemple.address, fontSize: 1),
      _printLine("Phone: ${currentTemple.phoneNumber}", fontSize: 1),
      _dividerLine(),
      _leftLine("Date: $receiptDate    Time: $receiptTime"),
      _leftLine("Receipt No: $receiptNo"),
      _dividerLine(),
      _leftLine("Sl Name   Star   Vazhi   Qty Amt", fontSize: 1),
      _dividerLine(),
    ];

    for (int i = 0; i < receipts.length; i++) {
      final item = receipts[i];
      final name = (item['personName'] ?? '').toString();
      final star = (item['personStar'] ?? '').toString();
      final vazhipadu = (item['offerName'] ?? '').toString();
      final qty = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
      final rate = int.tryParse(item['rate']?.toString() ?? '0') ?? 0;
      final amt = qty * rate;
      totalAmount += amt;


      final row =
          '${(i + 1).toString().padRight(2)} '
          '${_clip(name, 6)} '
          '${_clip(star, 5)} '
          '${_clip(vazhipadu, 6)} '
          '${qty.toString().padLeft(2)} '
          '${'₹$amt'.padLeft(5)}';

      lines.add(_leftLine(row));
    }

    lines.add(_dividerLine());
    lines.add(_printLine("Total: ₹$totalAmount", fontSize: 2));
    return lines;
  }

  static Map<String, dynamic> _printLine(String data, {int fontSize = 1}) {
    return {
      "PrintDataType": "0",
      "PrinterWidth": 32,
      "IsCenterAligned": true,
      "FontSize": fontSize,
      "IsBold": false,
      "DataToPrint": data,
      "ImagePath": "0",
      "ImageData": "0",
    };
  }

  static Map<String, dynamic> _leftLine(String data, {int fontSize = 1}) {
    return {
      "PrintDataType": "0",
      "PrinterWidth": 32,
      "IsCenterAligned": false,
      "FontSize": fontSize,
      "IsBold": false,
      "DataToPrint": data,
      "ImagePath": "0",
      "ImageData": "0",
    };
  }

  static Map<String, dynamic> _dividerLine() {
    return _leftLine("-" * 32);
  }

  static String _clip(String text, int width) {
    return text.length > width ? text.substring(0, width) : text.padRight(width);
  }

  static String _formattedDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }

  static String _formattedTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}