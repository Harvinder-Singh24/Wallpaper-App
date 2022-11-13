import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/modals/photo_modal.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import '../utils/api_key.dart';

class WallpaperProvider with ChangeNotifier {
  List<PhotosModel> _wallpapers = [];

  List<PhotosModel> get wallpaper => _wallpapers;

  List<PhotosModel> _searchWallpaper = [];

  List<PhotosModel> get searchWallpaper => _searchWallpaper;

  List<String> _savedWallpapers = [];

  List<String> get savedWallpapers => _savedWallpapers;

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
      PhotosModel model = PhotosModel();
      model = PhotosModel.fromMap(element);
      _wallpapers.add(model);
    });

    isLoading = false;
    notifyListeners();
  }

  void clear_search_data() {
    _searchWallpaper.clear();
    notifyListeners();
  }

  void save_img(String imgurl) {
    _savedWallpapers.add(imgurl);
    notifyListeners();
  }

  void search_data(String query) async {
    print("Search APi Calls");
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=100"),
        headers: {
          'Authorization': API_KEY,
        });
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    jsonResponse['photos'].forEach((element) {
      PhotosModel model = PhotosModel();
      model = PhotosModel.fromMap(element);
      _searchWallpaper.add(model);
    });
    notifyListeners();
  }

  //function to set the wallpaper
  void setHomeWallpaper(String url, context) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManagerFlutter.HOME_SCREEN;
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      showToast(
          "Wallpaper Set",
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
      notifyListeners();
    } catch (e) {
      showToast(
          e.toString(),
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
      print(e);
      notifyListeners();
    }
  }

  //function to set the wallpaper on lock screen
  void setLockScreen(String url, context) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManagerFlutter.LOCK_SCREEN;
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      showToast(
          "Wallpaper Set",
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
      notifyListeners();
    } catch (e) {
      showToast(
          e.toString(),
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
      notifyListeners();
    }
  }

  //function to set the wallpaper on botn screen
  void setBothScreen(String url, context) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManagerFlutter.BOTH_SCREENS;
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      showToast(
          "Wallpaper Set",
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
      notifyListeners();
    } catch (e) {
      showToast(
          e.toString(),
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
      notifyListeners();
    }
  }
}
