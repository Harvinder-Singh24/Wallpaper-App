import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/screens/imageview_page.dart';

import '../modals/wallpaper_model.dart';

Widget TitleWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      Text("Wallpaper", style: TextStyle(color: Colors.black)),
      Text("Hub", style: TextStyle(color: Colors.blue))
    ],
  );
}

WallpaperView({required List<WallpaperModel> wallpapers, context}) {
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.count(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          childAspectRatio: 0.5,
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 6.0,
          crossAxisCount: 2,
          children: wallpapers.map((e) {
            return GridTile(
                child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageViewPage(
                            imageurl: e.srcModel!.portrait.toString())));
              },
              child: Hero(
                tag: e.srcModel!.portrait.toString(),
                child: SizedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: e.srcModel!.portrait.toString(),
                      imageBuilder: (context, provider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: provider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => const Center(
                          child: Icon(Icons.access_time_rounded,
                              color: Colors.grey)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error_outline_rounded),
                    ),
                  ),
                ),
              ),
            ));
          }).toList()));
}
