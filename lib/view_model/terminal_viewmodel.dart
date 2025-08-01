import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/logger.dart';

class TerminalViewmodel with ChangeNotifier {
  String _selectedTransaction = 'SALE';
  bool _isChecked = false;
  List<String> statusMessages = [];
  bool printerEnabled = false;

  void setPrintDataFromVazhipadu(List<Map<String, dynamic>> groupedData) {
    List<Map<String, dynamic>> dataToPrint = [];

    for (var group in groupedData) {
      final int serial = group['serialNumber'] ?? 'NoSerial';
      final List receipts = group['receipts'] ?? [];

      dataToPrint.add({
        "PrintDataType": "0",
        "PrinterWidth": 24,
        "IsCenterAligned": true,
        "DataToPrint": "Receipt Number: $serial",
        "ImagePath": "0",
        "ImageData": "0"
      });

      dataToPrint.add({
        "PrintDataType": "0",
        "PrinterWidth": 24,
        "IsCenterAligned": true,
        "DataToPrint": "------------------------",
        "ImagePath": "0",
        "ImageData": "0"
      });

      for (var item in receipts) {
        final name = item['personName'] ?? 'Unknown';
        final offerName = item['offerName'] ?? 'Unknown';
        final qty = item['quantity'] ?? 1;
        final rate = item['rate'] ?? 0;
        final total = qty * rate;

        dataToPrint.add({
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": false,
          "DataToPrint": "$name - $offerName: ₹$total",
          "ImagePath": "0",
          "ImageData": "0"
        });
      }

      dataToPrint.add({
        "PrintDataType": "0",
        "PrinterWidth": 24,
        "IsCenterAligned": true,
        "DataToPrint": "------------------------",
        "ImagePath": "0",
        "ImageData": "0"
      });
    }

    printData = {
      "Header": {
        "ApplicationId": "f0d097be4df3441196d1e37cb2c98875",
        "UserId": "user1234",
        "MethodId": "1002",
        "VersionNo": "1.0",
      },
      "Detail": {
        "PrintRefNo": "RECEIPT${DateTime.now().millisecondsSinceEpoch}",
        "SavePrintData": false,
        "Data": dataToPrint,
      }
    };

    notifyListeners();
  }



  Map<String, dynamic> payload = {
    "Detail": {
      "BillingRefNo": "TX98765432",
      "PaymentAmount": 100,
      "TransactionType": 4001,
    },
    "Header": {
      "ApplicationId": "f0d097be4df3441196d1e37cb2c98875",
      "MethodId": "1001",
      "UserId": "user1234",
      "VersionNo": "1.0",
    }
  };
  Map<String, dynamic> printData = {
    "Header": {
      "ApplicationId": "f0d097be4df3441196d1e37cb2c98875",
      "UserId": "user1234",
      "MethodId": "1002",
      "VersionNo": "1.0",
    },
    "Detail": {
      "PrintRefNo": "RECEIPT123456",
      "SavePrintData": false,
      "Data": [
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": 'asdfasdf',
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "123 Main Street",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "City, State, ZIP",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "Receipt Number: RECEIPT12345",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "Date: 2024-10-27 10:30 AM",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "------------------------",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": false,
          "DataToPrint": "Item 1: INR 10.00",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": false,
          "DataToPrint": "Item 2: INR 20.00",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "------------------------",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": false,
          "DataToPrint": "Total: INR 30.00",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "------------------------",
          "ImagePath": "0",
          "ImageData": "0"
        },
        {
          "PrintDataType": "3",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "RECEIPT12345",
          "ImagePath": "",
          "ImageData": ""
        },
        {
          "PrintDataType": "4",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "https://example.com/receipt/RECEIPT12345",
          "ImagePath": "",
          "ImageData": ""
        },
        {
          "PrintDataType": "0",
          "PrinterWidth": 24,
          "IsCenterAligned": true,
          "DataToPrint": "Thank You!",
          "ImagePath": "0",
          "ImageData": "0"
        }
      ]
    },
  };
  TextEditingController jsonController = TextEditingController(
      text: const JsonEncoder.withIndent('').convert({
        "Header": {
          "ApplicationId": "f0d097be4df3441196d1e37cb2c98875",
          "UserId": "user1234",
          "MethodId": "1002",
          "VersionNo": "1.0",
        },
        "Detail": {
          "PrintRefNo": "123456789",
          "SavePrintData": false,
          "Data": [
            {
              "PrintDataType": "0",
              "PrinterWidth": 24,
              "IsCenterAligned": true,
              "DataToPrint": "String Data",
              "ImagePath": "0",
              "ImageData": "0"
            },
            // Add other print data items here
          ],
        },
      }));
  final TextEditingController amountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();

  String _bindingStatus = "Not Bound";
  bool _isBound = false;
  bool _isBindingInitiated = false; // Add this flag
  ScrollController scrollController = ScrollController();
  int _paymentAmount = 100; // Store the payment amount

  String get bindingStatus => _bindingStatus;
  bool get isBound => _isBound;
  bool get isBindingInitiated => _isBindingInitiated;
  int get paymentAmount => _paymentAmount;

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void setBindingStatus(String status) {
    _bindingStatus = status;
    notifyListeners();
  }

  void setIsBound(bool bound) {
    _isBound = bound;
    notifyListeners();
  }

  void setBindingInitiated(bool value) {
    _isBindingInitiated = value;
    notifyListeners();
  }

  void setPaymentAmount(int amount){
    _paymentAmount = amount;
    notifyListeners();
  }

  // Getters
  String get selectedTransaction => _selectedTransaction;
  bool get isChecked => _isChecked;

  // Setters
  void setSelectedTransaction(String value) {
    _selectedTransaction = value;
    // Update printerEnabled based on the selected transaction
    printerEnabled = value == 'PRINT';
    Logger.info('Selected Transaction: $value, Printer Enabled: $printerEnabled');
    notifyListeners();
  }

  void setIsChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  // Methods
  void addStatusMessage(String message) {
    String currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
    statusMessages.add('$currentTime :  $message');
    notifyListeners();
    Timer(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void updatePrintData(String value) {
    try {
      var parsedData = jsonDecode(value);
      printData = convertToMapOfMaps(parsedData);
    } catch (e) {
      Logger.error('Error parsing JSON: $e');
    }
    notifyListeners();
  }

  Map<String, dynamic> convertToMapOfMaps(Map<String, dynamic> data) {
    Map<String, dynamic> result = {};
    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result[key] = value;
      }
    });
    return result;
  }

  Future<void> process(BuildContext context) async {
    if(printerEnabled) {

    }
  }
}