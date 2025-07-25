import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ReceiptPrinter {
  static Future<void> printReceipt({
    required String serialNumber,
    required String name,
    required String star,
    required String poojaDate,
    required String postalCharge,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // Print to Console for Debugging
      print("🖨️ Printing Receipt...");
      print("Serial Number: $serialNumber");
      print("Name: $name");
      print("Star: $star");
      print("Pooja Date: $poojaDate");
      print("Postal Charge: ₹$postalCharge");
      print("Items:");
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        print("${i + 1}. ${item['name']} | Qty: ${item['quantity']} | ₹${item['amount']}");
      }

      // === START PRINT LAYOUT ===
      final now = DateTime.now();
      final formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(now);

      // Header
      String receipt = '';
      receipt += '         YOUR TEMPLE NAME HERE\n';
      receipt += '        Address Line 1, City, PIN\n';
      receipt += '          Phone: 9876543210\n';
      receipt += '------------------------------------------\n';
      receipt += 'Receipt No: $serialNumber\n';
      receipt += 'Date      : $formattedDate\n';
      receipt += 'Name      : $name\n';
      receipt += 'Star      : $star\n';
      receipt += 'Pooja Date: $poojaDate\n';
      receipt += '------------------------------------------\n';
      receipt += 'No. Item Name             Qty     Amount\n';
      receipt += '------------------------------------------\n';

      // Items
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final index = (i + 1).toString().padRight(3);
        final itemName = item['name']?.toString() ?? '';
        final displayName = itemName.length > 22
            ? itemName.substring(0, 22)
            : itemName.padRight(22);
        final qty = item['quantity'].toString().padLeft(5);
        final amount = "₹${item['amount']}".padLeft(10);

        receipt += '$index$displayName$qty$amount\n';

        // Optional: Show name/star below each item
        receipt += '    $name\n';
        receipt += '     ($star)\n';
      }

      // Footer
      receipt += '------------------------------------------\n';
      receipt += 'Postal Charge: ₹$postalCharge\n';
      receipt += '------------------------------------------\n';
      receipt += 'Thank you for your offerings.\n';
      receipt += 'Visit Again!\n';
      receipt += '------------------------------------------\n\n';

      // === Call to Thermal Printer (pseudo) ===
      // Example using blue_thermal_printer or your POS API
      // final printer = BlueThermalPrinter.instance;
      // if (await printer.isConnected == true) {
      //   printer.printNewLine();
      //   printer.printCustom(receipt, 1, 1); // 1=font size, 1=centered
      //   printer.printNewLine();
      // }

      // For now, just print to console
      debugPrint(receipt);

    } catch (e) {
      print("❌ Error in printReceipt: $e");
    }
  }
}
