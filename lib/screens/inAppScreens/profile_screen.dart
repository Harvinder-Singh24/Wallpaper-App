import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper/screens/authScreens/register_screen.dart';
import 'package:wallpaper/screens/splash_screen.dart';
import 'package:wallpaper/services/auth_service.dart';
import 'package:wallpaper/services/database_service.dart';
import 'package:wallpaper/utils/colors.dart';
import 'package:wallpaper/utils/helper.dart';
import 'package:path/path.dart';
import '../../provider/connectivity_provider.dart';

class ProfileScreen extends StatefulWidget {
  bool isSkipped;
  ProfileScreen({Key? key, required this.isSkipped}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  bool isSwitched = false;
  String? name;
  String? email;
  File? image;
  String downloadedUrl = '';
  final userRef = FirebaseFirestore.instance.collection('users');

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getData();
    print("either skipped or not ${widget.isSkipped}");
    super.initState();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
          source: source, maxWidth: 512, maxHeight: 512, imageQuality: 75);
      if (image == null) return;
      Reference ref = FirebaseStorage.instance.ref().child("profilepic");
      await ref.putFile(File(image.path));
      ref.getDownloadURL().then((value) => {
            setState(() {
              downloadedUrl = value;
            })
          });
      print("IMage Uploaded");
      // final imageTemprary = File(image.path);
      //final imageTemprary = await saveImagePermanetly(image.path);
      /*setState(() {
        this.image = imageTemprary;
      });
      print("IMage Saved ");*/

    } on PlatformException catch (e) {
      print("Failed to pick the image");
    }
  }

  Future<File> saveImagePermanetly(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  void getData() async {
    await for (var snapshot in userRef.snapshots()) {
      for (var document in snapshot.docs) {
        setState(() {
          name = document['Name'];
          email = document['email'];
        });
      }
    }

    /*final SharedPreferences sharedpreference =
        await SharedPreferences.getInstance();
    var namegot = sharedpreference.getString('name');
    var emailgot = sharedpreference.getString('email');
    print("Name got from Shared Prefrnces ${name}");
    print("Email got from Shared Prefrences ${email}");*/
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
      body: pageUI(context),
    );
  }

  Widget pageUI(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, modal, child) {
      if (modal.isOnline != null) {
        return modal.isOnline ?? false
            ? widget.isSkipped
                ? skippedProfileUI(context)
                : profilescreenUI(context)
            : NoInternet();
      }
      return const Center(child: CircularProgressIndicator());
    });
  }

  Widget skippedProfileUI(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            const Text("Register to see Profile"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              },
              child: Container(
                width: 349,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.indigo[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text("Confirm",
                      style: TextStyle(
                          color: backgroundColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profilescreenUI(BuildContext context) {
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
                  children: [
                    CircleAvatar(
                      radius: 60,
                      child: downloadedUrl == ''
                          ? null
                          : Image.network(downloadedUrl, fit: BoxFit.cover),
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
                                        "Choose Image",
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
                                            onTap: () {
                                              pickImage(ImageSource.gallery);
                                              Navigator.pop(context);
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
                                                child: Text("Gallery",
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
                                              pickImage(ImageSource.camera);
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
                                                child: Text("Camera",
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
                      child: const CircleAvatar(
                          radius: 20, child: Icon(IconlyLight.camera)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            Text(
              email.toString(),
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
                                              _authService.signOut();
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text("Logout")));
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SplashScreen()));
                                              SharedPreferences
                                                  sharedPreferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              sharedPreferences.setBool(
                                                  "islogin", false);
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
