import 'package:crimer/navigation_drawer/drawerwidget.dart';
import 'package:flutter/material.dart';

class aboutus extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _aboutusState createState() => _aboutusState();
}

class _aboutusState extends State<aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerwidget(),
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Card(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                height: 200,
                width: MediaQuery.of(context).size.width,
                image: AssetImage("images/crime.jpg"),
                fit: BoxFit.contain,
              ),
              SizedBox(height: 15.0),
              Text(
                'Who we are?',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                "Crime Reports that maintains the data of criminal. When you observe a crime being committed you can input the details of the culprits into our app and report it on the moment with all the necessary information.This application will make it simple for you to fill in the spaces.",
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 10.0),
              Text(
                'Our Policy',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                'Our terms & conditions!',
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
