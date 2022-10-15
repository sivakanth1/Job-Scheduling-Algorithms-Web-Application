// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:jsaos/pages/inputpage.dart';
import 'package:jsaos/pages/resultpage.dart';
import 'pages/home.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'JSA OS',
          theme: ThemeData.dark(),
          initialRoute: Homepage.id,
          routes: {
            InputPage.id: (context) => const InputPage(),
            Homepage.id: (context) => const Homepage(),
            ResultPage.id: (context) => const ResultPage(),
          },
        );
      },
    );
  }
}
