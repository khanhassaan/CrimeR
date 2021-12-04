import 'package:crimer/navigation_drawer/drawerwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crimer/Start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'addcrimedetails.dart';
import 'showcrimedetails.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Start()));
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  Widget fetchCrimes() {
    EasyLoading.show(status: "Loading Data");
    //Snapshot for docs
    final Stream<QuerySnapshot> crimeDetails = FirebaseFirestore.instance
        .collection('CrimeDetails')
        .where('uid', isEqualTo: _auth.currentUser?.uid)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: crimeDetails,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        EasyLoading.dismiss();
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                navigatetoCrime(data);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: const Color.fromRGBO(39, 38, 67, 10),
                elevation: 10,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 60,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Date: " + data['date'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        ),
                        Text(
                          "Crime Type: " + data['crime_type'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          "Crime Scene at: " + data['crime_loc'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  navigatetoCrime(Map<String, dynamic> data) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => showcrimedetails(data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crime Details"),
      ),
      drawer: drawerwidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return addcrimedetails();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
                'https://www.vskills.in/certification/blog/wp-content/uploads/2015/08/Crime-Reporting.png'),
          ),

          Expanded(child: fetchCrimes()),
          //Text(imgUrl[1])
        ],
      ),
    );
  }
}
