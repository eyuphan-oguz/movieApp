import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie/view/apiDeneme.dart';
import 'package:movie/view/homeView.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main()async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FEYMovie',
      theme:  ThemeData(scaffoldBackgroundColor: const Color(0xff000000)),

      home: HomePage(),
    );
  }
}





