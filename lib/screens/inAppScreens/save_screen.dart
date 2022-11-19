import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/provider/main_provider.dart';
import 'package:wallpaper/utils/colors.dart';
import 'package:wallpaper/utils/helper.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {

  int saved_count = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);
    saved_count = provider.savedWallpapers.length;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          "Saved",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin:const  EdgeInsets.symmetric(horizontal: 20 , vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                  "${saved_count} Wallpapers saved",
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                child: GridView.builder(
                  shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  itemCount: saved_count,
                    gridDelegate: const  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemBuilder: (context , index) {
                      return GridTile(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                        imageUrl: provider.savedWallpapers[index],
                                        placeholder: (context, url) => Container(
                                          color: const Color(0xfff5f8fd),
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.vertical(top: Radius.circular(25.0)),
                                      ),
                                      builder: (builder) {
                                        return Container(
                                            height: 120,
                                            margin: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text("Unsave this Wallpaper" ,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w900
                                                ),),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        provider.remove_img(index);
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("Wallpaper Unsaved"))
                                                        );
                                        },
                                                      child: Container(
                                                        width: 120,
                                                        height: 56,
                                                        decoration: BoxDecoration(
                                                          color: Colors.indigo[600],
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Center(
                                                          child: Text("Yes",
                                                              style: TextStyle(
                                                                  color: backgroundColor,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w700)),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        width: 120,
                                                        height: 56,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Center(
                                                          child: Text("No",
                                                              style: TextStyle(
                                                                  color: Colors.indigo[600],
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w700)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                        );
                                      });
                      },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.indigo,
                                    child: const Icon(IconlyLight.bookmark,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                      );
                    }),
              ),
            ],
          )
        )
      ),
    );
  }
}
