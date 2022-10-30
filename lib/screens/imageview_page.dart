import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/widgets/appbar_widgets.dart';

class ImageViewPage extends StatefulWidget {
  final String imageurl;
  const ImageViewPage({Key? key, required this.imageurl}) : super(key: key);

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (builder) {
                  return Container(
                      height: 60,
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              provider.setHomeWallpaper(
                                  widget.imageurl, context);
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: const [
                                Icon(Icons.phone_iphone_rounded,
                                    color: Colors.grey, size: 30),
                                SizedBox(height: 10),
                                Text("Home Screen",
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.setLockScreen(widget.imageurl, context);
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: const [
                                Icon(Icons.phonelink_lock_rounded,
                                    color: Colors.grey, size: 30),
                                SizedBox(height: 10),
                                Text("Lock Screen",
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.setBothScreen(widget.imageurl, context);
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: const [
                                Icon(Icons.phonelink_rounded,
                                    color: Colors.grey, size: 30),
                                SizedBox(height: 10),
                                Text("Both Screen",
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                          )
                        ],
                      ));
                });
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.wallpaper_rounded, color: Colors.black)),
      body: Stack(
        children: [
          Hero(
            tag: widget.imageurl,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CachedNetworkImage(
                imageUrl: widget.imageurl,
                imageBuilder: (context, provider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: provider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const Center(
                    child: Icon(Icons.access_time_rounded, color: Colors.grey)),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error_outline_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
