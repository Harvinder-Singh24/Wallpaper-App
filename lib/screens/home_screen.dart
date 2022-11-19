import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wallpaper/screens/inAppScreens/category_screen.dart';
import 'package:wallpaper/screens/inAppScreens/main_screen.dart';
import 'package:wallpaper/screens/inAppScreens/profile_screen.dart';
import 'package:wallpaper/screens/inAppScreens/save_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List pages = const [
    MainScreen(),
    CatergoryScreen(),
    SaveScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.indigo[600],
            selectedIconTheme: IconThemeData(color: Colors.indigo[600]),
            unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
            items: const [
              BottomNavigationBarItem(
                  label: "Home", icon: Icon(IconlyBold.home)),
              BottomNavigationBarItem(
                  label: "Category", icon: Icon(IconlyBold.category)),
              BottomNavigationBarItem(
                  label: "Save", icon: Icon(IconlyBold.bookmark)),
              BottomNavigationBarItem(
                  label: "profile", icon: Icon(IconlyBold.profile))
            ]),
        body: WillPopScope(
          child: pages[_currentIndex],
          onWillPop: () {
            SystemNavigator.pop();
            throw "Cannot Back";
          },
        ));
  }
}
