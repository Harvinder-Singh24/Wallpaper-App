import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  int page = 1;
  int search_page = 1;
  bool isLoading = false;
  String? result;

  WallpaperProvider() {
    getSavedData();
  }

  void getSavedData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? _gotList = sharedPreferences.getStringList('items');
    print("Wallpapers got from shared Prefrences ${_gotList}");
    _savedWallpapers = _gotList ?? [];
    notifyListeners();
  }

  //function to fetch the _wallpapers
  void getData() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });

    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?page=$page&per_page=1000"),
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  void clear_search_data() {
    _searchWallpaper.clear();
    notifyListeners();
  }

  void print_save_wallpapers() {
    print(" Saved Wallpaper List ${_savedWallpapers}");
  }

  void save_img(String imgurl) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _savedWallpapers.add(imgurl);
    sharedPreferences.setStringList('items', _savedWallpapers);
    notifyListeners();
  }

  void remove_img(int index) async {
    _savedWallpapers.removeAt(index);
    notifyListeners();
  }

  void search_data(String query) async {
    print("Search APi Calls");
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&page=$search_page&per_page=1000"),
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
      showToast("Wallpaper Set",
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
    } catch (e) {
      showToast(e.toString(),
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
      print(e);
    }
  }

  //function to set the wallpaper on lock screen
  void setLockScreen(String url, context) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManagerFlutter.LOCK_SCREEN;
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      showToast("Wallpaper Set",
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
    } catch (e) {
      showToast(e.toString(),
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
    }
  }

  //function to set the wallpaper on botn screen
  void setBothScreen(String url, context) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    int location = WallpaperManagerFlutter.BOTH_SCREENS;
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      showToast("Wallpaper Set",
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
    } catch (e) {
      showToast(e.toString(),
          context: context,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.black),
          animation: StyledToastAnimation.scale);
    }
  }
}
