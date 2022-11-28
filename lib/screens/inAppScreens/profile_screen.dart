import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/screens/splash_screen.dart';
import 'package:wallpaper/services/auth_service.dart';
import 'package:wallpaper/utils/colors.dart';
import 'package:wallpaper/utils/helper.dart';

import '../../provider/connectivity_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  bool isSwitched = false;
  String? name;
  String? email;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    final SharedPreferences sharedpreference =
        await SharedPreferences.getInstance();
    var namegot = sharedpreference.getString('name');
    var emailgot = sharedpreference.getString('email');

    print("Name got from Shared Prefrnces ${name}");
    print("Email got from Shared Prefrences ${email}");
  }

  void toogleSwitched(bool value) {
    if (value == true) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Name is ${name}");
    print("Email is ${email}");
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: pageUI(),
    );
  }

  Widget pageUI() {
    return Consumer<ConnectivityProvider>(builder: (context, modal, child) {
      if (modal.isOnline != null) {
        return modal.isOnline ?? false ? profilescreenUI() : NoInternet();
      }
      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget profilescreenUI() {
    AuthService _authService = AuthService();
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Center(
              child: Container(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: const [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                        "https://media.istockphoto.com/id/1300972574/photo/millennial-male-team-leader-organize-virtual-workshop-with-employees-online.jpg?b=1&s=170667a&w=0&k=20&c=96pCQon1xF3_onEkkckNg4cC9SCbshMvx0CfKl2ZiYs=",
                      ),
                    ),
                    CircleAvatar(radius: 20, child: Icon(IconlyLight.camera))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name.toString() ?? '',
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            Text(
              email.toString() ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
              child: Column(
                children: [
                  options_row(IconlyLight.notification, "Notifications", true),
                  const SizedBox(
                    height: 20,
                  ),
                  options_row(IconlyLight.activity, "Feedback", false),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0)),
                            ),
                            builder: (builder) {
                              return Container(
                                  height: 120,
                                  margin: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Want to Logout",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              SharedPreferences
                                                  sharedPreferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              _authService.signOut();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text("Logout")));
                                              sharedPreferences.setBool(
                                                  "islogin", false);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SplashScreen()));
                                            },
                                            child: Container(
                                              width: 120,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: Colors.indigo[600],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text("Yes",
                                                    style: TextStyle(
                                                        color: backgroundColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 120,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text("No",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.indigo[600],
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ));
                            });
                      },
                      child: options_row(IconlyLight.logout, "Logout", false)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget options_row(IconData icon, String text, bool wantSwitch) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 20),
        Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 10),
        wantSwitch
            ? Switch(
                value: isSwitched,
                onChanged: toogleSwitched,
                activeColor: Colors.white,
                activeTrackColor: Colors.indigo[600],
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              )
            : Container(),
      ],
    );
  }
}
