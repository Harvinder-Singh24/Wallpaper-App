import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/utils/helper.dart';
import 'package:wallpaper/utils/strin_extension.dart';

import '../provider/main_provider.dart';

class SearchPage extends StatefulWidget {
  final String query;
  const SearchPage({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<WallpaperProvider>(context, listen: false);
      provider.search_data(widget.query);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wallpapers = Provider.of<WallpaperProvider>(context);
    var searchQuery = widget.query.capitalize();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(searchQuery,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white),
      body: WillPopScope(
        onWillPop: () async {
          print("Data Cleared");
          wallpapers.clear_search_data();
          wallpapers.search_page = 1;
          return true;
        },
        child: RefreshIndicator(
          color: Colors.purple,
          onRefresh: () async {
            wallpapers.search_page++;
            wallpapers.searchWallpaper.clear();
            wallpapers.search_data(searchQuery);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  wallPaper(wallpapers.searchWallpaper, context),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
