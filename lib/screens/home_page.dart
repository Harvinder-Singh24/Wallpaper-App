import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/modals/categorie_model.dart';
import 'package:wallpaper/modals/wallpaper_model.dart';
import 'package:wallpaper/provider/wallpaper_provider.dart';
import 'package:wallpaper/screens/search_page.dart';
import 'package:wallpaper/utils/api_key.dart';
import 'package:wallpaper/utils/categori_list.dart';
import 'package:wallpaper/widgets/appbar_widgets.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategorieModel> categorie = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<WallpaperProvider>(context, listen: false).getData();
    });
    categorie = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    final wallpapers = Provider.of<WallpaperProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TitleWidget(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (searchController.text != '') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(
                                controller: searchController,
                              ),
                            ),
                          );
                        } else {
                          showToast(
                            "Invalid Search",
                            context: context,
                            animation: StyledToastAnimation.scale,
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(color: Colors.black),
                          );
                        }
                      },
                      controller: searchController,
                      decoration: const InputDecoration(
                          hintText: "search wallpapers",
                          border: InputBorder.none),
                    )),
                    InkWell(
                        onTap: () {
                          if (searchController.text != '') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  controller: searchController,
                                ),
                              ),
                            );
                          } else {
                            showToast(
                              "Invalid Search",
                              context: context,
                              animation: StyledToastAnimation.scale,
                              backgroundColor: Colors.white,
                              textStyle: const TextStyle(color: Colors.black),
                            );
                          }
                        },
                        child: const Icon(Icons.search))
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Made By ",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontFamily: 'Overpass'),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Harvinder Singh",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontFamily: 'Overpass'),
                      )),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 24,
              ),
              WallpaperView(wallpapers: wallpapers.wallpaper, context: context),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Photos provided By ",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontFamily: 'Overpass'),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Pexels",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontFamily: 'Overpass'),
                      ))
                ],
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorieTile extends StatelessWidget {
  final imageUrl, title;
  const CategorieTile({Key? key, @required this.imageUrl, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ));
  }
}
