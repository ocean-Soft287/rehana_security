import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rehana_security/core/network/local/flutter_secure_storage.dart';
import '../../core/router/app_router.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      final rememberMe = await SecureStorageService.read(SecureStorageService.rememberme);

      if (!mounted) return; // ✅ الحل هنا

      if (rememberMe == "true") {
        context.go(AppRouter.home);
      } else {
        SecureStorageService.deleteAll();
        context.go(AppRouter.kLoginview);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: child,
            );
          },
          child: Image.asset(
            "assets/images/logo.png",
            width: 268,
            height: 353,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
