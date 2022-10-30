import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpaper/screens/home_page.dart';

import '../widgets/appbar_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.white, child: Center(child: TitleWidget())),
    );
  }
}
