import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    setState(() {
      name = namegot;
      email = emailgot;
    });
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
                  options_row(IconlyLight.logout, "Logout", false),
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
