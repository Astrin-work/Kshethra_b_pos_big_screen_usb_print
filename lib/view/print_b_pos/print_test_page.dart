import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintTestPage extends StatefulWidget {
  const PrintTestPage({super.key});

  @override
  State<PrintTestPage> createState() => _PrintTestPageState();
}

class _PrintTestPageState extends State<PrintTestPage> {
  static const MethodChannel _platform = MethodChannel('printer_channel');

  Future<void> _printReceipt() async {
    String message;


    final granted = await _requestBluetoothPermissions();
    if (!granted) {
      _showSnackBar("Bluetooth permissions not granted.");
      return;
    }

    try {
      final receipt = '''
           📿 TEMPLE RECEIPT 📿
----------------------------------------
Temple Name       : Sree Krishna Temple
Address           : Guruvayoor, Kerala
Phone             : 0487-2556789
----------------------------------------
Date              : ${DateTime.now().toString().split(" ").first}
Receipt No.       : ABC-12345
Name              : Anurag
Phone             : 9876543210
Star              : Rohini
----------------------------------------
Vazhipadu         Qty         Amount
Archana           1           ₹50.00
Ganapathi Homam   2           ₹150.00
----------------------------------------
TOTAL                         ₹200.00
----------------------------------------
🙏 Thank you! Visit again. 🙏
\n\n\n
''';

      final result = await _platform.invokeMethod('printReceipt', {
        'text': receipt,
      });

      message = "Print result: $result";
    } on PlatformException catch (e) {
      message = "Print failed: ${e.message}";
    }

    _showSnackBar(message);
  }

  Future<bool> _requestBluetoothPermissions() async {
    final status = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    return status.values.every((permission) => permission.isGranted);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Print Test Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: _printReceipt,
          child: const Text("🖨️ Print Receipt"),
        ),
      ),
    );
  }
}
