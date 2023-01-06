// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  late Size size;

  final GlobalKey _qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? _controller;
  Barcode? result;

  final bool _isBuild = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    if (!_isBuild && _controller != null) {
      setState(() {
        _controller?.pauseCamera();
        _controller?.resumeCamera();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF7524F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('QR Code Scanner'),
            const SizedBox(
              width: 20,
            ),
            Image.asset(
              "images/qr.jpg",
              width: 40.0,
              height: 40.0,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 9,
              child: _buildQrView(context),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: const Color(0xffe3dfdf),
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _controller?.toggleFlash();
                      },
                      child: const Icon(
                        Icons.flash_on,
                        size: 24,
                        color: Color(0xffF7524F),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _controller?.flipCamera();
                      },
                      child: const Icon(
                        Icons.flip_camera_ios,
                        size: 24,
                        color: Color(0xffF7524F),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    //small area for scanning
    var scanArea = 250.0;

    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
        cutOutSize: scanArea,
        borderWidth: 10,
        borderLength: 40,
        borderRadius: 5.0,
        borderColor: const Color(0xffF7524F),
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      _controller = qrController;
    });

    _controller?.scannedDataStream.listen((event) {
      setState(() {
        result = event;
        _controller?.pauseCamera();
      });

      if (result?.code != null) {
        // ignore: avoid_print
        print("QR code Scanned and showing Result");
        _showResult();
      }
    });
  }

  void onPermissionSet(
      BuildContext context, QRViewController _ctrl, bool _permission) {
    if (!_permission) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No Permission!'),
      ));
    }
  }

  Widget _showResult() {
    bool _validURL = Uri.parse(result!.code.toString()).isAbsolute;

    return Center(
      child: FutureBuilder<dynamic>(
        future: showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                child: AlertDialog(
                  title: const Text(
                    'Scan Result!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: SizedBox(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _validURL
                            ? SelectableText.rich(
                                TextSpan(
                                    text: result!.code.toString(),
                                    style: const TextStyle(
                                      color: Color(0xffF7524F),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(
                                            Uri.parse(result!.code.toString()));
                                      }),
                              )
                            : Text(
                                result!.code.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _controller?.resumeCamera();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF7524F),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ),
                            shadowColor: const Color(0xffF7524F),
                          ),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
                onWillPop: () async => false,
              );
            }),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          throw UnimplementedError;
        },
      ),
    );
  }
}
