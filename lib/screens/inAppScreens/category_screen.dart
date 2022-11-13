import 'package:flutter/material.dart';

class CatergoryScreen extends StatefulWidget {
  const CatergoryScreen({Key? key}) : super(key: key);

  @override
  State<CatergoryScreen> createState() => _CatergoryScreenState();
}

class _CatergoryScreenState extends State<CatergoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Category Screen"));
  }
}
