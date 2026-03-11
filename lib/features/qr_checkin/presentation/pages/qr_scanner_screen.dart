import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/checkin_bloc.dart';
import '../bloc/checkin_event.dart';
import '../bloc/checkin_state.dart';
import '../../../../di/service_locator.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late CheckInBloc _bloc;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _bloc = sl<CheckInBloc>();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String code = barcodes.first.rawValue!;
      setState(() => _isProcessing = true);
      _bloc.add(ScanQrCodeRequested(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan QR Ticket')),
        body: BlocConsumer<CheckInBloc, CheckInState>(
          listener: (context, state) {
            if (state is CheckInSuccess) {
              final result = state.checkInResult;
              if (result.status == 'SUCCESS') {
                 _showResultDialog('Success', 'Checked in ${result.customerName} (Ticket #${result.ticketId})', Colors.green);
              } else {
                 _showResultDialog('Error', result.message, Colors.red);
              }
            } else if (state is CheckInError) {
              _showResultDialog('Error', state.message, Colors.red);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                MobileScanner(
                  onDetect: _onDetect,
                  controller: MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates),
                ),
                if (_isProcessing || state is CheckInLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Position the QR code within the frame',
                      style: const TextStyle(color: Colors.white, fontSize: 16, backgroundColor: Colors.black54),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _showResultDialog(String title, String message, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _isProcessing = false); // Resume scanning
            },
            child: const Text('Scan Next'),
          )
        ],
      )
    );
  }
}
