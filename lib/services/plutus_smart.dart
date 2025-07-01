import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import '../utils/logger.dart';

class PlutusSmart {
  static const MethodChannel _channel = MethodChannel('plutus_channel');

  static Future<String> bindToService() async {
    try {
      final result = await _channel.invokeMethod('bindToService');
      Logger.info('bindToService result: $result');
      return result;
    } catch (e) {
      Logger.error('bindToService error: $e');
      // Return a fallback success message if service is not available
      return "SERVICE_NOT_AVAILABLE";
    }
  }

  static Future<String> startTransaction(String transactionData) async {
    try {
      final result = await _channel.invokeMethod('startTransaction', {
        'transactionData': transactionData,
      });
      return result;
    } catch (e) {
      Logger.error('startTransaction error: $e');
      return "TRANSACTION_FAILED: ${e.toString()}";
    }
  }

  static Future<String> startPrintJob(String printData) async {
    try {
      final result = await _channel.invokeMethod('startPrintJob', {
        'printData': printData,
      });
      return result;
    } catch (e) {
      Logger.error('startPrintJob error: $e');
      // Fallback to console printing if service is not available
      return _fallbackPrint(printData);
    }
  }

  static String _fallbackPrint(String printData) {
    try {
      Logger.info('🖨️ Fallback printing (Plutus service not available)');
      
      // Parse the print data and format it for console output
      Map<String, dynamic> data;
      try {
        data = Map<String, dynamic>.from(json.decode(printData));
      } catch (e) {
        Logger.error('Failed to parse print data as JSON: $e');
        return "JSON_PARSE_ERROR: ${e.toString()}";
      }
      
      if (data.containsKey('Detail') && data['Detail'] is Map) {
        final detail = data['Detail'] as Map<String, dynamic>;
        if (detail.containsKey('Data') && detail['Data'] is List) {
          final lines = detail['Data'] as List;
          Logger.info('🧾 === RECEIPT ===');
          for (var line in lines) {
            if (line is Map && line.containsKey('DataToPrint')) {
              final text = line['DataToPrint'] as String;
              final isBold = line['IsBold'] == true;
              final fontSize = line['FontSize'] ?? 1;
              final isCenter = line['IsCenterAligned'] == true;
              
              String prefix = '';
              if (isBold) prefix += '**';
              if (fontSize > 1) prefix += '#';
              if (isCenter) prefix += '  ';
              
              Logger.info('$prefix$text');
            }
          }
          Logger.info('🧾 === END RECEIPT ===');
          return "PRINTED_TO_CONSOLE";
        }
      }
      
      // If we can't parse the structure, just log the raw data
      Logger.info('Raw print data: ${printData.substring(0, printData.length > 200 ? 200 : printData.length)}...');
      return "PRINT_DATA_LOGGED";
    } catch (e) {
      Logger.error('Fallback print error: $e');
      return "FALLBACK_PRINT_FAILED: ${e.toString()}";
    }
  }
}