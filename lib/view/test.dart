import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  static const platform = MethodChannel('plutus_channel');

  Future<ui.Image> generateReceiptBitmap(String currentDate) async {
    const width = 576;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(width.toDouble(), 1000)));

    final textStyle = ui.TextStyle(color: Colors.black, fontSize: 22);
    final paragraphStyleCenter = ui.ParagraphStyle(textAlign: TextAlign.center);
    final paragraphStyleLeft = ui.ParagraphStyle(textAlign: TextAlign.left);

    // Header
    final header = ui.ParagraphBuilder(paragraphStyleCenter)
      ..pushStyle(ui.TextStyle(fontSize: 50.0, color: Colors.black))
      ..addText("Sample text");
    final headerParagraph = header.build()
      ..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(headerParagraph, Offset((width - headerParagraph.width) / 2, 40));

    double yOffset = 150.0;

    // Receipt No
    final receiptPara = ui.ParagraphBuilder(paragraphStyleLeft)
      ..pushStyle(textStyle)
      ..addText("Receipt No: 1234");
    final p1 = receiptPara.build()
      ..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(p1, Offset(20, yOffset));
    yOffset += 35;

    // Date
    final datePara = ui.ParagraphBuilder(paragraphStyleLeft)
      ..pushStyle(textStyle)
      ..addText("Date: $currentDate");
    final p2 = datePara.build()
      ..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(p2, Offset(20, yOffset));
    yOffset += 65;

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, yOffset.toInt());
    return img;
  }

  Future<void> _print() async {
    String currentDate =
        "2025-04-28";
    final image = await generateReceiptBitmap(currentDate);

    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);
    final Uint8List byteArray = byteData.buffer.asUint8List();

    try {
      final String result = await platform.invokeMethod('printReceipt', {
        'image': byteArray,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to print: '${e.message}'");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _print,
              child: const Text('Print'),
            ),
          ],
        ),
      ),
    );
  }
}
