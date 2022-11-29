import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:wallpaper/provider/connectivity_provider.dart';
import 'package:wallpaper/screens/authScreens/login_screen.dart';
import 'package:wallpaper/screens/authScreens/register_screen.dart';
import 'package:wallpaper/utils/colors.dart';
import 'package:wallpaper/utils/helper.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    isUserLoggedIn();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  void isUserLoggedIn() async {
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    final bool? repeat = sharedpreference.getBool('islogin');
    print("Shared value got  ${repeat}");
    Future.delayed(
        Duration.zero,
        () => {
              if (repeat == true)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen())),
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: pageUI(),
    );
  }

  Widget pageUI() {
    return Consumer<ConnectivityProvider>(builder: (context, modal, child) {
      if (modal.isOnline != null) {
        return modal.isOnline ?? false ? splashUI() : NoInternet();
      }
      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget splashUI() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ShowUpAnimation(
            delayStart: const Duration(seconds: 1),
            animationDuration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            direction: Direction.vertical,
            offset: 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Walldeco",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "High Quality Wallpapers",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 250),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 349,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.indigo[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text("Register",
                          style: TextStyle(
                              color: backgroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text("Already have an account ?",
                          style: TextStyle(
                              color: thirdColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w300)),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: Text("Log In",
                            style: TextStyle(
                                color: thirdColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
