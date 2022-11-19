import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/screens/search_screen.dart';

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  const CategoriesTile({required this.imgUrls, required this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              query: categorie,
            ),
          ),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imgUrls,
                  height: 200,
                  width: 350,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  categorie ?? "Yo Yo",
                  style: TextStyle(
                    color: Colors.indigo[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
