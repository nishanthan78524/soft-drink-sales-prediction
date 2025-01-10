import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String scannedBarcode = 'No barcode scanned';

  // Function to start barcode scanning
  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();  // Start the barcode scanning
      if (result.rawContent.isNotEmpty) {
        setState(() {
          scannedBarcode = result.rawContent;  // Update the barcode text
        });
      }
    } catch (e) {
      setState(() {
        scannedBarcode = 'Failed to scan barcode: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scanned Barcode:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              scannedBarcode,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scan Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}
