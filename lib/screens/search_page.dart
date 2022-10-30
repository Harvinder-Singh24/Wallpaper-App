import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/utils/string_extension.dart';
import '../widgets/appbar_widgets.dart';

class SearchPage extends StatefulWidget {
  final TextEditingController controller;
  const SearchPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    print(widget.controller.text);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<WallpaperProvider>(context, listen: false);
      provider.search_data(widget.controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wallpapers = Provider.of<WallpaperProvider>(context);
    var searchQuery = widget.controller.text.capitalize();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(searchQuery,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  wallpapers.clear_search_data();
                },
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black)),
            elevation: 0,
            backgroundColor: Colors.white),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 24,
                ),
                WallpaperView(
                    wallpapers: wallpapers.searchWallpaper, context: context),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Photos provided By ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontFamily: 'Overpass'),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Pexels",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontFamily: 'Overpass'),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
