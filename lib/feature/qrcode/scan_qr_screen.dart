import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../core/images/font.dart';
import '../accept_and_refuse/presentation/views/screen/enterandexit.dart';

class ScanQrScreen extends StatefulWidget {
  final String name;

  const ScanQrScreen({super.key, required this.name});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;
  bool navigated = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      if (!isScanning && scanData.code != null && scanData.code!.isNotEmpty) {
        isScanning = true;
        controller.pauseCamera();

        try {
          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EnterandExit(
                name: widget.name,
                qrData: scanData.code!,
              ),
            ),
          ).then((_) {
            controller.resumeCamera();
            isScanning = false;
          });
        } catch (e) {
          isScanning = false;
          controller.resumeCamera();
        }

      }

    });
  }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  void _startScan() {
    controller?.resumeCamera();
    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QRView(
                  key: qrKey,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.white,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 5,
                    cutOutSize: MediaQuery.of(context).size.width * 0.6,
                  ),
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text(
                "مسح الكود",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: Font.alex,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
