import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/main_provider.dart';
import '../modals/photo_modal.dart';
import '../screens/inAppScreens/imageview.dart';

Widget wallPaper(List<PhotosModel> listPhotos, BuildContext context) {
  final wallpapers = Provider.of<WallpaperProvider>(context);
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6.0,
            children: listPhotos.map((PhotosModel photoModel) {
              return GridTile(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageView(
                        imgPath: photoModel.src!.portrait.toString(),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: photoModel.src!.portrait.toString(),
                  child: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                            imageUrl: photoModel.src!.portrait.toString(),
                            placeholder: (context, url) => Container(
                                  color: const Color(0xfff5f8fd),
                                ),
                            fit: BoxFit.cover)),
                  ),
                ),
              ));
            }).toList()),
      ),
    ],
  );
}

Widget NoInternet() {
  return Center(child: Lottie.asset("assets/animation/nointernet.json"));
}
