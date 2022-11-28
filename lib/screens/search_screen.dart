import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wallpaper/provider/connectivity_provider.dart';
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
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<WallpaperProvider>(context, listen: false);
      provider.search_data(widget.query);
      Provider.of<ConnectivityProvider>(context, listen: false)
          .startMonitoring();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: finalUI(),
    );
  }

  Widget finalUI() {
    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      if (model.isOnline != null) {
        return model.isOnline ?? false
            ? searchUI(widget.query.capitalize())
            : NoInternet();
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget searchUI(String searchtext) {
    final wallpapers = Provider.of<WallpaperProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        print("Data Cleared");
        wallpapers.clear_search_data();
        wallpapers.search_page = 1;
        return true;
      },
      child: SmartRefresher(
        physics: const BouncingScrollPhysics(),
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        onLoading: () async {
          wallpapers.search_page++;
          wallpapers.search_data(searchtext);
          _refreshController.loadComplete();
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
    );
  }
}
