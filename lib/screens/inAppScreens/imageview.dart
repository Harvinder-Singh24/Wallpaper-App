import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/main_provider.dart';

class ImageView extends StatefulWidget {
  final String imgPath;

  const ImageView({required this.imgPath});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: widget.imgPath,
                placeholder: (context, url) => Container(
                  color: const Color(0xfff5f8fd),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        //saving the wallpapers
                        provider.save_img(widget.imgPath);
                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Wallpaper Saved")));
                        print(provider.savedWallpapers.length);
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: 40,
                              height: 40,
                              color: Colors.white,
                              child: const Icon(IconlyLight.bookmark,
                                  color: Colors.indigo),),),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Modal Bottom Sheet Opened");
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.vertical(top: Radius.circular(25.0)),
                              ),
                              builder: (builder) {
                                return Container(
                                    height: 100,
                                    margin: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            provider.setHomeWallpaper(
                                                widget.imgPath, context);
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children:  [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: Colors.indigo[600]
                                                ),
                                                child: const Icon(Icons.phone_iphone_rounded,
                                                    color: Colors.white, size: 30),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text("Home ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            provider.setLockScreen(widget.imgPath, context);
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children:  [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.indigo[600]
                                                ),
                                                child: const Icon(Icons.phonelink_lock_rounded,
                                                    color: Colors.white, size: 30),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text("Lock ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            provider.setBothScreen(widget.imgPath, context);
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children:  [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.indigo[600]
                                                ),
                                                child: const  Icon(Icons.phonelink_rounded,
                                                    color: Colors.white, size: 30),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text("Both ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.black))
                                            ],
                                          ),
                                        )
                                      ],
                                    ));
                              });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text("Apply",
                              style: TextStyle(
                                  color: Colors.indigo[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _saveImage(widget.imgPath, context),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: 40,
                              height: 40,
                              color: Colors.white,
                              child: Icon(IconlyLight.download,
                                  color: Colors.indigo[600]))),
                    )
                  ],
                ),
                const SizedBox(height: 12)
              ],
            ),
          )
        ],
      ),
    );
  }

  void _saveImage(String url, BuildContext context) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/myfile.jpg';
    await Dio().download(url, path);
    await GallerySaver.saveImage(path);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Downloaded to Gallery")));
  }

}
