import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/auth/login.dart';
import 'package:almoktar/components/text.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with TickerProviderStateMixin {
  final List<String> changingTexts = ["شاورما", "همبرغر", "كريسبي"];
  final List<String> images = [
    "assets/images/shawarma.png",
    "assets/images/hamm.png",
    "assets/images/crespe.png",
  ];

  int currentIndex = 0;
  bool showFinalScreen = false;

  late AnimationController _alMukhtarController;
  late Animation<double> _alMukhtarPositionAnimation;
  late Animation<double> _alMukhtarScaleAnimation;
  late AnimationController _beilbekController;
  late Animation<double> _beilbekPositionAnimation;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) {
        setState(() {
          currentIndex++;
          if (currentIndex >= changingTexts.length) {
            currentIndex = changingTexts.length;
            showFinalScreen = true;
            timer.cancel();

            // بدء الحركات النهائية
            _alMukhtarController.forward();
            _beilbekController.forward();

            // الانتقال بعد 4 ثواني
            Timer(const Duration(seconds: 6), () {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
            });
          }
        });
      }
    });

    _alMukhtarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _alMukhtarPositionAnimation = Tween<double>(begin: 800, end: 200).animate(
      CurvedAnimation(parent: _alMukhtarController, curve: Curves.easeOut),
    );
    _alMukhtarScaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _alMukhtarController, curve: Curves.easeInOut),
    );

    _beilbekController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _beilbekPositionAnimation = Tween<double>(begin: 800, end: 280).animate(
      CurvedAnimation(parent: _beilbekController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _alMukhtarController.dispose();
    _beilbekController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // خلفية بتدرج لوني من ألوان الثيم
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // عرض النصوص والصور المتغيرة قبل النهاية
          if (!showFinalScreen) ...[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text1: "عبالك",
                    size: 36,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: CustomText(
                      key: ValueKey<int>(currentIndex),
                      text1:
                          currentIndex < changingTexts.length
                              ? changingTexts[currentIndex]
                              : "",
                      size: 28,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // AnimatedSwitcher(
                  //   duration: const Duration(milliseconds: 800),
                  //   child:
                  //       currentIndex < images.length
                  //           ? ClipOval(
                  //             key: ValueKey<int>(currentIndex),
                  //             child: Image.asset(
                  //               images[currentIndex],
                  //               width: 250,
                  //               height: 250,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           )
                  //           : const SizedBox.shrink(),

                  // ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child:
                        currentIndex < images.length
                            ? Image.asset(
                              images[currentIndex],
                              key: ValueKey<int>(currentIndex),
                              width: 250,
                              height: 250,
                              fit:
                                  BoxFit
                                      .cover, // يمكنك تغييره لـ BoxFit.contain إذا أردت
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ] else ...[
            // شاشة النهاية: شعار المختار + نصوص الحركة
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/images/almukhtar.png",
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _alMukhtarController,
              builder: (context, child) {
                return Positioned(
                  top: _alMukhtarPositionAnimation.value,
                  left: 0,
                  right: 0,
                  child: Transform.scale(
                    scale: _alMukhtarScaleAnimation.value,
                    child: Center(
                      child: CustomText(
                        text1: "المختار",
                        size: 40,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _beilbekController,
              builder: (context, child) {
                return Positioned(
                  top: _beilbekPositionAnimation.value,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CustomText(
                      text1: "بيلبيك",
                      size: 28,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
