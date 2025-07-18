import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({Key? key}) : super(key: key);

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> with SingleTickerProviderStateMixin {
  bool isScanned = false;
  String? scannedCode;
  late AnimationController _controller;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();

    // تحريك الليزر من الأعلى للأسفل
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);

    _laserAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (isScanned) return;

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      final code = barcode.rawValue;
      if (code != null) {
        isScanned = true;
        scannedCode = code;

        HapticFeedback.mediumImpact(); // اهتزاز خفيف

        AppCubit.get(context).accept_external_order(code: code);
      }
    }
  }

  void _showThankYouDialogAndClose() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🎉 شكراً!'),
        content: const Text('✅ تم قبول الطلب بنجاح'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تم'),
          ),
        ],
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppSates>(
      listener: (context, state) {
        if (state is accept_external_orderSuccessState) {
          _showThankYouDialogAndClose();
        } else if (state is accept_external_orderErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('حدث خطأ أثناء قبول الطلب')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              MobileScanner(
                onDetect: _onDetect,
              ),
              Positioned.fill(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'وجّه الكود نحو الإطار لمسحه',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    // مربع المسح مع ليزر متحرك
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Stack(
                        children: [
                          Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _laserAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top: _laserAnimation.value * 250,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.redAccent.withOpacity(0.8),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text('إلغاء'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
