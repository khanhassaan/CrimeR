import 'dart:async';
import 'dart:io';
import 'Homepage.dart';
import 'package:crimer/Homepage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorageRef;
import 'package:path/path.dart' as Path;
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'navigation_drawer/drawerwidget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class addcrimedetails extends StatefulWidget {
  @override
  State<addcrimedetails> createState() => _addcrimedetailsState();
}

enum ImageSourceType { gallery, camera }

class _addcrimedetailsState extends State<addcrimedetails> {
  //get user from firebase

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloggedin = false;
  User? user = FirebaseAuth.instance.currentUser;
  //Text Controller
  final textController_1 = TextEditingController();
  final textController_2 = TextEditingController();
  final textController_3 = TextEditingController();
  //to fetch current date and time
  final DateTime _now = DateTime.now();
  //List of crime types
  static final List crimetypes = [
    "Murder",
    "Robbery",
    "Child Abuse",
    "Threats",
    "Others"
  ];

  //String for dropdown button
  String? _crimeType = null;
  //Firebase storage instance
  firebaseStorageRef.Reference? storageRef;

  List<File> imageList = [];
  final ImagePicker _imagePicker = ImagePicker();

  //multiple image  upload
  multipleImageUpload() async {
    List<XFile>? selectedImages;
    try {
      selectedImages = await _imagePicker.pickMultiImage(
          imageQuality: 85, maxHeight: 200, maxWidth: 200);
    } catch (e) {
      print(e);
    }
    setState(() {
      for (var i = 0; i < selectedImages!.length; i++) {
        imageList.add(File(selectedImages[i].path));
      }
    });
  }

//Creating Grid view for selected images
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(imageList.length, (index) {
        File file = imageList[index];
        return Image.file(file);
      }),
    );
  }

//for current position
  Position? _curPos;
  //for current address
  String? _curAdd;

  //Fetching latitude and longitude
  getCurrentLocation() async {
    _curPos = await Geolocator.getCurrentPosition();
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position pos) {
      setState(() {
        _curPos = pos;
        getCurrentLocationAdd();
      });
    }).catchError((e) {
      print(e);
    });
  }

//Converting lat and lon to address
  getCurrentLocationAdd() async {
    try {
      List<Placemark> listPlaceMarks =
          await placemarkFromCoordinates(_curPos!.latitude, _curPos!.longitude);
      Placemark place = listPlaceMarks[0];

      setState(() {
        _curAdd = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Widget loadProgressIndicator() {
    return CircularProgressIndicator();
  }

  //Storing data in firestore database
  Future submitData() async {
    List<String> imageUrl = [];
    //TextData
    String text1, text2, text3;
    text1 = textController_1.text;
    text2 = textController_2.text;
    text3 = textController_3.text;
    bool caseSolved = false;
    if (text2 == "" || text3 == "" || imageList.isEmpty) {
      showAlertDialog();
    } else {
      EasyLoading.show(dismissOnTap: false, status: "Uploading Data");
      try {
        Firebase.initializeApp();
        for (File img in imageList) {
          String fileName = Path.basename(img.path);
          storageRef = firebaseStorageRef.FirebaseStorage.instance.ref().child(
              'CrimeImages/${_auth.currentUser?.uid}/${_now.hour}${_now.minute}${_now.second}/$fileName');
          await storageRef?.putFile(img).whenComplete(() async {
            await storageRef
                ?.getDownloadURL()
                .then((value) => imageUrl.add(value));
          });
        }

        FirebaseFirestore.instance
            .collection("CrimeDetails")
            .doc(
                "${_auth.currentUser?.uid}+${_now.hour}+${_now.minute}+${_now.second}")
            .set({
          "uid": "${user?.uid}",
          "uname": "${user?.displayName}",
          "time": "${_now.hour}:${_now.minute}",
          "date": "${_now.day}:${_now.month}:${_now.year}",
          "name_criminal": "${text1}",
          "crime_loc": "${text3}",
          "crime_type": "${_crimeType}",
          "crime_details": "${text2}",
          "case_solved": "${caseSolved}",
          "current_location": "${_curAdd}",
          "image_url": FieldValue.arrayUnion(imageUrl)
        }).then((value) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess("Successfull");
          successMessage();
        });
      } catch (e) {
        print(e);
      }
    }
  }

  successMessage() {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Homepage()));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success"),
      content: const Text("Data Uploaded successfully!!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog() {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Fill all Field "),
      content: const Text("Please Enter data in all required fields"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  //progress bar
  void main(List<String> args) {
    configLoading();
  }

  Timer? _timer;
  late double _progress;
  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Crime Details"),
      ),
      drawer: drawerwidget(),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          //TextField name of criminal

          /*const Padding(
            padding: EdgeInsets.all(10),
            child: 
          ),*/

          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: textController_1,
              decoration: const InputDecoration(
                hintText: "If You Know",
                labelText: "Name of Criminal",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          //Textfield details of crime
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: textController_2,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Enter Details'),
                MaxLengthValidator(200, errorText: 'Max Length Exceeds'),
                MinLengthValidator(0,
                    errorText: 'Please enter atleast 20 characterss')
              ]),
              decoration: const InputDecoration(
                suffixText: '*',
                suffixStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
                hintText: "If You Know",
                labelText: "Details of Crime",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          //textfield crime scene location
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: textController_3,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Enter Details'),
                MaxLengthValidator(200, errorText: 'Max Length Exceeds'),
                MinLengthValidator(0,
                    errorText: 'Please enter atleast 20 characterss')
              ]),
              decoration: const InputDecoration(
                suffixText: '*',
                suffixStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
                labelText: "Crime Scene Location",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          //Drop Down Menu
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton(
                  hint: const Text("Crime Type"),
                  value: _crimeType,
                  onChanged: (newValue) {
                    setState(() {
                      _crimeType = newValue.toString();
                    });
                  },
                  items: crimetypes.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList()),
            ),
          ),
          Row(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  onPressed: multipleImageUpload,
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: const Color.fromRGBO(39, 38, 67, 10)),
              SizedBox(
                width: 50,
              ),
              MaterialButton(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  onPressed: () {
                    setState(() {
                      imageList.clear();
                      buildGridView();
                    });
                  },
                  child: const Text(
                    'Clear Selection',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: const Color.fromRGBO(39, 38, 67, 10)),
            ],
          ),
          Expanded(
            child: buildGridView(),
          ),

          //Upload Image/Video button
          Row(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  onPressed: () {
                    submitData();
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: const Color.fromRGBO(39, 38, 67, 10)),
            ],
          ),
        ],
      ),
    );
  }
}
