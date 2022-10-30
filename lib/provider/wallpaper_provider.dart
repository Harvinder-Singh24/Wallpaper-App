import 'dart:convert';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import '../modals/wallpaper_model.dart';
import '../utils/api_key.dart';

class WallpaperProvider with ChangeNotifier {
  List<WallpaperModel> _wallpapers = [];
  List<WallpaperModel> _searchWallpaper = [];
  List<WallpaperModel> get wallpaper => _wallpapers;
  List<WallpaperModel> get searchWallpaper => _searchWallpaper;
  int page = 100;
  bool isLoading = false;
  String? result;

  //function to fetch the _wallpapers
  void getData() async {
    isLoading = true;
    notifyListeners();

    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=50"),
        headers: {
          'Authorization': API_KEY,
        });
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    jsonResponse['photos'].forEach((element) {
      WallpaperModel model = WallpaperModel();
      model = WallpaperModel.fromMap(element);
      _wallpapers.add(model);
    });

    isLoading = false;
    notifyListeners();
  }

  void clear_search_data() {
    _searchWallpaper.clear();
    notifyListeners();
  }

  void search_data(String query) async {
    print("Search APi Calls");
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=50"),
        headers: {
          'Authorization': API_KEY,
        });
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    jsonResponse['photos'].forEach((element) {
      WallpaperModel model = WallpaperModel();
      model = WallpaperModel.fromMap(element);
      _searchWallpaper.add(model);
    });
    notifyListeners();
  }

  //function to set the wallpaper
  void setHomeWallpaper(String url, context) async {
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
      //Set an animation
      showToast(
        result,
        context: context,
        animation: StyledToastAnimation.scale,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
      );
    } on PlatformException {
      result = 'Failed to get wallpaper.';
      //Set an animation
      showToast(
        result,
        context: context,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
        animation: StyledToastAnimation.scale,
      );
    }
  }

  //function to set the wallpaper on lock screen
  void setLockScreen(String url, context) async {
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
      //Set an animation
      showToast(
        result,
        context: context,
        animation: StyledToastAnimation.scale,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
      );
    } on PlatformException {
      result = 'Failed to get wallpaper.';
      //Set an animation
      showToast(
        result,
        context: context,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
        animation: StyledToastAnimation.scale,
      );
    }
  }

  //function to set the wallpaper on botn screen
  void setBothScreen(String url, context) async {
    try {
      result = await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
      )
          ? 'Wallpaper set'
          : 'Failed to get wallpaper.';
      //Set an animation
      showToast(
        result,
        context: context,
        animation: StyledToastAnimation.scale,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
      );
    } on PlatformException {
      result = 'Failed to get wallpaper.';
      //Set an animation
      showToast(
        result,
        context: context,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(color: Colors.black),
        animation: StyledToastAnimation.scale,
      );
    }
  }
}
