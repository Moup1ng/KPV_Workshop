import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/news.dart';
import 'widget/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => News(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF072342)),
      ),
      home: const MyHomePage(),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int strength in strengths) {
    swatch[strength] = Color.fromRGBO(r, g, b, strength / 900);
  }

  return MaterialColor(color.value, swatch);
}
