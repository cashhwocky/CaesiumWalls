import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.waves_rounded,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        size: 48,
                      ),
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
