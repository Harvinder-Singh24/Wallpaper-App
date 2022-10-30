import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/screens/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WallpaperProvider>(
      create: (_) => WallpaperProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
