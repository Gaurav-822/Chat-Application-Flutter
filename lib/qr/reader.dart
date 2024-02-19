import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Reader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Reader();
}

class _Reader extends State<Reader> {
  String _scanResult = 'No scan result';

  Future<void> _scanQRCode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } catch (e) {
      scanResult = 'Error: $e';
    }

    if (!mounted) return;

    setState(() {
      _scanResult = scanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return QRScannerScreen();
  }
}

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String _scanResult = 'No scan result';

  Future<void> _scanQRCode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.DEFAULT);
    } catch (e) {
      scanResult = 'Error: $e';
    }

    if (!mounted) return;

    setState(() {
      _scanResult = scanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Scan Result:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              _scanResult,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text('Scan'),
        onPressed: _scanQRCode,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
