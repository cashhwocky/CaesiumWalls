import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CaesiumWallsApp());
}

class CaesiumWallsApp extends StatelessWidget {
  const CaesiumWallsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme darkColorScheme = darkDynamic?.harmonized() ?? 
          ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark);

        return MaterialApp(
          title: 'CaesiumWalls',
          debugShowCheckedModeBanner: false, // This removes the red DEBUG banner
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            scaffoldBackgroundColor: Colors.black, 
          ),
          home: const WallpaperGridScreen(),
        );
      },
    );
  }
}

class WallpaperGridScreen extends StatelessWidget {
  const WallpaperGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.black,
            title: Text(
              'CaesiumWalls',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.55, 
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    // Replaced the placeholder icon with the procedural art generator
                    child: CustomPaint(
                      painter: ProceduralWallpaperPainter(
                        seed: index, 
                        primaryColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: Container(), // Empty container lets the canvas fill the card
                    ),
                  )
                  .animate()
                  .scale(
                    delay: Duration(milliseconds: (index % 6) * 60),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutQuart,
                    begin: const Offset(0.85, 0.85),
                  )
                  .fadeIn(
                    duration: const Duration(milliseconds: 500),
                  );
                },
                childCount: 30, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// The Generative Math Engine
class ProceduralWallpaperPainter extends CustomPainter {
  final int seed;
  final Color primaryColor;
  final Color secondaryColor;

  ProceduralWallpaperPainter({required this.seed, required this.primaryColor, required this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed * 100); // Use the grid index to make each one unique

    // 1. Draw Pure AMOLED Black Background
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    // 2. Setup the Liquid Gradient
    final gradient = LinearGradient(
      colors: [primaryColor.withOpacity(0.8), secondaryColor.withOpacity(0.3), Colors.black],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Offset.zero & size);

    final wavePaint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill;

    // 3. Math for the Procedural Waves
    final path = Path();
    double startY = size.height * (0.3 + random.nextDouble() * 0.4);
    path.moveTo(0, startY);

    // Generate smooth bezier curves
    path.quadraticBezierTo(
      size.width * 0.25, startY + (random.nextDouble() * 100 - 50), 
      size.width * 0.5, startY + (random.nextDouble() * 50),
    );
    path.quadraticBezierTo(
      size.width * 0.75, startY + (random.nextDouble() * 150 - 20), 
      size.width, startY - (random.nextDouble() * 50),
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
    
    // Add a second overlapping wave for depth
    final path2 = Path();
    double startY2 = size.height * (0.5 + random.nextDouble() * 0.3);
    path2.moveTo(0, startY2);
    path2.quadraticBezierTo(
      size.width * 0.3, startY2 - (random.nextDouble() * 100), 
      size.width * 0.6, startY2 + (random.nextDouble() * 80),
    );
    path2.quadraticBezierTo(
      size.width * 0.8, startY2 - (random.nextDouble() * 40), 
      size.width, startY2 + (random.nextDouble() * 50),
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    final gradient2 = LinearGradient(
      colors: [secondaryColor.withOpacity(0.6), primaryColor.withOpacity(0.2)],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).createShader(Offset.zero & size);

    canvas.drawPath(path2, Paint()..shader = gradient2..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
