import 'package:crimer/aboutus.dart';
import 'package:crimer/admin_panel/adminhome.dart';
import 'package:crimer/case_solved/admin_casesolved.dart';
import 'package:crimer/case_solved/casesolved.dart';
import 'package:crimer/contactus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class navigation_admin extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_auth.currentUser!.displayName.toString()),
            accountEmail: Text(_auth.currentUser!.email.toString()),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => adminhome()));
            },
          ),
          ListTile(
            leading: Icon(Icons.check_box_outlined),
            title: Text("Cases Solved"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => admin_casesolved()));
            },
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text("Log Out"),
            onTap: () {
              Navigator.pop(context);
              _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
