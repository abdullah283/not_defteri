import 'package:bolum_28_not_sepeti/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not sepeti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.purple,
          primaryColor: Colors.orange),
      home: HomePage(),
    );
  }
}
