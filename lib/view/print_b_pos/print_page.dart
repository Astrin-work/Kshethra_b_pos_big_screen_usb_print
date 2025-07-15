
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});
  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  static const platform = MethodChannel('printer_channel');

  Future<void> _printReceipt() async {
    final customText = '''
  KSHEHTRA MINI TEMPLE

  Vazhipadu Receipt

  Name   : Anurag
  Star   : Rohini
  Date   : 2025-07-14

  Item             Qty     Amount
  -------------------------------
  Abhishekam        1      ₹150.00
  Archana           2      ₹100.00
  -------------------------------
  Total                    ₹250.00

  Thank you for your offerings!
  ''';

    try {
      final result = await platform.invokeMethod('printReceipt', {
        'text': customText,
      });
      debugPrint("Print success: $result");
    } on PlatformException catch (e) {
      debugPrint("Error: ${e.message}");
    }
  }


  Future<bool> requestBluetoothPermissions() async {
    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Print')),
      body: Center(
        child: ElevatedButton(
          onPressed: _printReceipt,
          child: const Text('Print Receipt'),
        ),
      ),
    );
  }
}
