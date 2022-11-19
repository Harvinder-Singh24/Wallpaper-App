import 'package:flutter/material.dart';
import 'package:wallpaper/modals/categorie_modal.dart';
import 'package:wallpaper/services/data.dart';
import 'package:wallpaper/utils/categories.dart';
import 'package:wallpaper/utils/helper.dart';

import '../../utils/colors.dart';

class CatergoryScreen extends StatefulWidget {
  const CatergoryScreen({Key? key}) : super(key: key);

  @override
  State<CatergoryScreen> createState() => _CatergoryScreenState();
}

class _CatergoryScreenState extends State<CatergoryScreen> {
  List<CategorieModel> categories = [];

  @override
  void initState() {
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          "Category",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              child: Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      /// Create List Item tile
                      return CategoriesTile(
                        imgUrls: categories[index].imgUrl.toString(),
                        categorie: categories[index].categorieName.toString(),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
