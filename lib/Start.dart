import 'package:flutter/material.dart';
import 'Login.dart';
import 'SignUp.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            Container(
              padding: EdgeInsets.only(left: 35, right: 30),
              child: Image(
                  image: AssetImage("images/CR.jpeg"),
                  width: 500,
                  height: 300,
                  fit: BoxFit.contain),
            ),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(
              text: 'Welcome!! ',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: '',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue))
              ],
            )),
            SizedBox(height: 10),
            Text(
              'Are you the EYE-witness of a crime? Report here',
              style: TextStyle(fontSize: 15.0, color: Colors.black),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: const Color.fromRGBO(39, 38, 67, 10)),
                SizedBox(width: 20),
                RaisedButton(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: const Color.fromRGBO(39, 38, 67, 10))
              ],
            )
          ],
        ),
      ),
    );
  }
}
