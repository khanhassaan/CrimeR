import 'package:flutter/material.dart';
import 'package:crimer/Homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Map<int, Color> color = {
    50: Color.fromRGBO(39, 38, 67, .1),
    100: Color.fromRGBO(39, 38, 67, .2),
    200: Color.fromRGBO(39, 38, 67, .3),
    300: Color.fromRGBO(39, 38, 67, .4),
    400: Color.fromRGBO(39, 38, 67, .5),
    500: Color.fromRGBO(39, 38, 67, .6),
    600: Color.fromRGBO(39, 38, 67, .7),
    700: Color.fromRGBO(39, 38, 67, .8),
    800: Color.fromRGBO(39, 38, 67, .9),
    900: Color.fromRGBO(39, 38, 67, 1),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: MaterialColor(0xFF272643, color)),
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      builder: EasyLoading.init(),
    );
  }
}
