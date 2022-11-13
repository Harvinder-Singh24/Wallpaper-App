import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/modals/photo_modal.dart';
import 'package:wallpaper/provider/main_provider.dart';
import 'package:wallpaper/utils/api_key.dart';
import 'package:wallpaper/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/utils/helper.dart';

import '../search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<WallpaperProvider>(context, listen: false).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    final wallpapers = Provider.of<WallpaperProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          "Walldeco",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff5f8fd),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          controller: searchController,
                          decoration: const InputDecoration(
                              hintText: "search wallpapers",
                              hintStyle: TextStyle(fontSize: 14),
                              border: InputBorder.none),
                        )),
                        GestureDetector(
                            onTap: () {
                              if (searchController.text != '') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(
                                      controller: searchController,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Invalid Search")),
                                );
                              }
                            },
                            child: const Icon(IconlyLight.search))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          const Text("Today", style: TextStyle(fontSize: 18))),
                  const SizedBox(height: 20),
                  wallPaper(wallpapers.wallpaper, context)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
