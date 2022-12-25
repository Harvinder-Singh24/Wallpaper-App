import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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

    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: const Color(0xff373A36),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );

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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo[600],
          child: const Icon(
            Icons.brightness_3,
            color: Colors.white,
          ),
          onPressed: () {
            _fabAnimationController.reset();
            _borderRadiusAnimationController.reset();
            _borderRadiusAnimationController.forward();
            _fabAnimationController.forward();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const [
            IconlyBold.home,
            IconlyBold.category,
            IconlyBold.bookmark,
            IconlyBold.profile
          ],
          backgroundColor: Colors.white10,
          activeIndex: _selectedPageIndex,
          splashColor: const Color(0xffFFA400),
          notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => {
                _selectedPageIndex = index,
                _pageController.jumpToPage(_selectedPageIndex),
              }),
          hideAnimationController: _hideBottomBarAnimationController,

          //other params
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
