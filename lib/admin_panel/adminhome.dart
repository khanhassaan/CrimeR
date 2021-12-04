import 'package:crimer/admin_panel/adminshowcrime.dart';
import 'package:crimer/navigation_drawer/navigation_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crimer/Start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class adminhome extends StatefulWidget {
  @override
  _adminhomeState createState() => _adminhomeState();
}

class _adminhomeState extends State<adminhome> {
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

  List<dynamic> imgUrl = [];

  Widget fetchCrimes() {
    EasyLoading.show(status: "Loading Data");
    //Snapshot for docs
    final Stream<QuerySnapshot> crimeDetails = FirebaseFirestore.instance
        .collection('CrimeDetails')
        .where('case_solved', isEqualTo: "false")
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
            imgUrl = data['image_url'] as List<dynamic>;

            return GestureDetector(
              onTap: () {
                navigatetoCrime(data);
              },
              onLongPress: () {
                showCaseSolved(doc);
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

  showCaseSolved(doc) {
    String docId = doc.id.toString();
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        FirebaseFirestore collectionRef = FirebaseFirestore.instance;
        collectionRef
            .collection('CrimeDetails')
            .doc(docId)
            .update({'case_solved': "true"}).then(
                (value) => EasyLoading.showSuccess("Done!! Case is Solved"));
      },
    );
    Widget cancel = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Solved?"),
      content: const Text("Woulld you like mark case as Solved"),
      actions: [okButton, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  navigatetoCrime(Map<String, dynamic> data) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => adminshowcrime(data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home Page"),
      ),
      drawer: navigation_admin(),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            color: Colors.white,
          ),
          //Text("$imgUrl"),
          Expanded(child: fetchCrimes()),
          //Text(imgUrl[1])
        ],
      ),
    );
  }
}
