import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wallpaper/screens/inAppScreens/category_screen.dart';
import 'package:wallpaper/screens/inAppScreens/main_screen.dart';
import 'package:wallpaper/screens/inAppScreens/profile_screen.dart';
import 'package:wallpaper/screens/inAppScreens/save_screen.dart';

class HomeScreen extends StatefulWidget {
  bool isSkipped;
  HomeScreen({Key? key, required this.isSkipped}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  @override
  void initState() {
    _selectedPageIndex = 0;
    _pages = [
      //The individual tabs.
      const MainScreen(),
      const CatergoryScreen(),
      const SaveScreen(),
      ProfileScreen(
        isSkipped: widget.isSkipped,
      )
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: GNav(
              onTabChange: (index) {
                setState(() {
                  _selectedPageIndex = index;
                  _pageController.jumpToPage(_selectedPageIndex);
                });
              },
              selectedIndex: _selectedPageIndex,
              // tab button hover color
              haptic: true, // haptic feedback
              tabBorderRadius: 5,

              // tab button shadow
              curve: Curves.easeIn, // tab animation curves
              duration:
                  const Duration(milliseconds: 200), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.grey[800], // unselected icon color
              activeColor: Colors.indigo[600], // selected icon and text color
              iconSize: 24, // tab button icon size
              tabBackgroundColor: Colors.indigo
                  .withOpacity(0.1), // selected tab background color
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 8), // navigation bar padding
              tabs: const [
                GButton(
                  icon: IconlyBold.home,
                  text: 'Home',
                ),
                GButton(
                  icon: IconlyBold.category,
                  text: 'Category',
                ),
                GButton(
                  icon: IconlyBold.bookmark,
                  text: 'Saved',
                ),
                GButton(
                  icon: IconlyBold.profile,
                  text: 'Profile',
                )
              ]),
        ),
        body: WillPopScope(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          onWillPop: () {
            SystemNavigator.pop();
            throw "Cannot Back";
          },
        ));
  }
}


/* BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _selectedPageIndex = index;
                _pageController.jumpToPage(_selectedPageIndex);
              });
            },
            currentIndex: _selectedPageIndex,
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
            ]),*/
