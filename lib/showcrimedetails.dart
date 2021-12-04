import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class showcrimedetails extends StatefulWidget {
  final Map<String, dynamic> data;
  showcrimedetails(this.data);
  @override
  _showcrimedetailsState createState() => _showcrimedetailsState();
}

class _showcrimedetailsState extends State<showcrimedetails> {
  int _currentIndex = 0;
  List<dynamic> imageUrl = [];
  //Image Url

  void initstate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageUrl = widget.data['image_url'] as List<dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text("Crime Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                // enlargeCenterPage: true,
                //scrollDirection: Axis.vertical,
                onPageChanged: (index, reason) {
                  setState(
                    () {
                      _currentIndex = index;
                    },
                  );
                },
              ),
              items: imageUrl
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        margin: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        elevation: 6.0,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Image.network(
                                item,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageUrl.map((urlOfItem) {
                int index = imageUrl.indexOf(urlOfItem);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.8)
                        : Color.fromRGBO(0, 0, 0, 0.3),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              "Username: " + widget.data['uname'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Criminal: " + widget.data['name_criminal'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Crime: " + widget.data['crime_type'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Crime Location: " + widget.data['crime_loc'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Details: " + widget.data['crime_details'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Date: " +
                  widget.data['date'] +
                  "    Time: " +
                  widget.data['time'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "User's location: " + widget.data['current_location'],
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
