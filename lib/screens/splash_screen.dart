import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:solana_demo_task/provider/wallter_provider.dart';
import 'package:solana_demo_task/screens/wallet_connection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkTokenAndNavigate();
  }

  void _initAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Particle animations
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );
  }

  void _checkTokenAndNavigate() async {
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 1200));
    _textController.forward();

    // ✅ Check token validity
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    // Initialize the wallet provider
    await walletProvider.initialize();

    // Check if token exists and is valid
    if (walletProvider.jwtToken != null) {
      final remaining = walletProvider.remaining;

      print('========== TOKEN VERIFICATION ==========');
      print('Token exists: ${walletProvider.jwtToken != null}');
      print('Remaining time: ${remaining?.inSeconds ?? 0} seconds');

      // If token is expired or about to expire (less than 10 seconds)
      if (remaining == null || remaining.inSeconds <= 0) {
        print('⚠️ Token expired! Disconnecting wallet...');
        await walletProvider.disconnectWallet();
        print('✅ Wallet disconnected due to expired token');
      } else {
        print('✅ Token is valid');
      }
      print('========================================\n');
    } else {
      print('ℹ️ No token found - user not connected');
    }

    // Wait a bit more for smooth transition
    await Future.delayed(const Duration(milliseconds: 1500));

    // Navigate to main screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WalletConnectScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            _buildParticles(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  _buildLogo(),
                  const SizedBox(height: 40),

                  // Animated text
                  _buildText(),
                  const SizedBox(height: 20),

                  // Loading indicator
                  _buildLoadingIndicator(),
                ],
              ),
            ),

            // Bottom branding
            _buildBottomBranding(),
          ],
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particleController.value),
          child: Container(),
        );
      },
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotateAnimation.value * 0.2,
            child: Opacity(
              opacity: _logoOpacityAnimation.value,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple, Colors.deepPurple, Colors.blue],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(
                            0.5 * _pulseAnimation.value,
                          ),
                          blurRadius: 40 * _pulseAnimation.value,
                          spreadRadius: 10 * _pulseAnimation.value,
                        ),
                        BoxShadow(
                          color: Colors.blue.withOpacity(
                            0.3 * _pulseAnimation.value,
                          ),
                          blurRadius: 60 * _pulseAnimation.value,
                          spreadRadius: 15 * _pulseAnimation.value,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Outer ring
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        // Inner ring
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        // Wallet icon
                        Center(
                          child: Icon(
                            Icons.account_balance_wallet,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildText() {
    return FadeTransition(
      opacity: _textOpacityAnimation,
      child: SlideTransition(
        position: _textSlideAnimation,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Colors.white,
                  Colors.purple.shade200,
                  Colors.blue.shade200,
                ],
              ).createShader(bounds),
              child: Text(
                'Solana Wallet',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Secure • Fast • Reliable',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                letterSpacing: 3,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return FadeTransition(
      opacity: _textOpacityAnimation,
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade300),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Verifying...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBranding() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Connected to Devnet',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Powered by Solana',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for animated particles
class ParticlePainter extends CustomPainter {
  final double progress;
  final List<Particle> particles;

  ParticlePainter(this.progress)
    : particles = List.generate(30, (index) => Particle(index));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      final x = size.width * particle.x;
      final y = size.height * ((particle.y + progress * particle.speed) % 1.0);
      final opacity =
          (math.sin(progress * 2 * math.pi + particle.phase) + 1) / 2;

      paint.color = particle.color.withOpacity(opacity * 0.4);
      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Glow effect
      paint.color = particle.color.withOpacity(opacity * 0.2);
      canvas.drawCircle(Offset(x, y), particle.size * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
  final Color color;

  Particle(int seed)
    : x = (seed * 37) % 100 / 100.0,
      y = (seed * 71) % 100 / 100.0,
      size = 2 + (seed % 3).toDouble(),
      speed = 0.1 + (seed % 5) / 10.0,
      phase = (seed * 13) % 100 / 100.0 * 2 * math.pi,
      color = [
        Colors.purple,
        Colors.blue,
        Colors.deepPurple,
        Colors.cyan,
      ][seed % 4];
}
