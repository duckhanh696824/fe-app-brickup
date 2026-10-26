import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.linked_camera_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                  )
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 28),

              // App Name
              Text(
                'Brickup',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut),

              const SizedBox(height: 8),

              // Tagline
              Text(
                'Capture • Chain • Conquer',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 3,
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 60),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              )
                  .animate(delay: 1000.ms)
                  .fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
