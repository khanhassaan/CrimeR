import 'package:crimer/navigation_drawer/drawerwidget.dart';
import 'package:flutter/material.dart';

class contactus extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _contactusState createState() => _contactusState();
}

class _contactusState extends State<contactus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: drawerwidget(),
        appBar: AppBar(
          title: Text('Contact Us'),
        ),
        body: Container());
  }
}
