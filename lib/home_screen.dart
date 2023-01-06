import 'package:flutter/material.dart';
import 'package:qr_scanner/qrcode_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF7524F),
        title: const Center(
          child: Text(
            'QR Code Scanner',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: Container(
          alignment: Alignment.center,
          child: Image.asset(
            "images/qr.jpg",
            width: 50.0,
            height: 40.0,
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: const Color(0xffEEEEEE),
        child: Column(
          children: [
            const SizedBox(
              height: 300,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 200,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QrCodeScannerScreen()));
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
                  child: const Text('Scan QR Code'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
