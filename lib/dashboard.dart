import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'LoginPage.dart';
import 'all_users.dart';
import 'anounms_complains.dart';
import 'complains.dart';
import 'feedback.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int feedbackCount = 0;
  int anonymousFeedbackCount = 0;
  int pendingComplaintsCount = 0;
  int userCount = 0;

  int rejection=0;
  int acknowledged=0;

  int totalcompalins=0;





  void _logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));
  }






  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();

    // Get the current date and time
    final now = DateTime.now();

    // Calculate the start and end dates for the current month
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    // Reference to the Firestore collection
    final feedbackCollection = FirebaseFirestore.instance.collection('Feedback');

    // Query Firestore for feedback entries within the current month
    feedbackCollection
        .where('Timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('Timestamp', isLessThanOrEqualTo: endOfMonth)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        feedbackCount = querySnapshot.size; // Count of documents in the query result
      });
    }).catchError((error) {
      print('Error fetching feedback entries: $error');
    });


    final AnonymousCollection = FirebaseFirestore.instance.collection('Anonymous');
    AnonymousCollection .where('Timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('Timestamp', isLessThanOrEqualTo: endOfMonth)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        anonymousFeedbackCount = querySnapshot.size; // Count of documents in the query result
      });
    }).catchError((error) {
      print('Error fetching feedback entries: $error');
    });



    // Reference to the Firestore collection
    final complaintsCollection =
    FirebaseFirestore.instance.collection('Complains');

    // Query Firestore for pending complaints within the current month
    complaintsCollection
        .where('Status', isEqualTo: 'PENDING')

        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        pendingComplaintsCount = querySnapshot.size; // Count of documents in the query result
      });
    }).catchError((error) {
      print('Error fetching pending complaints: $error');
    });


    complaintsCollection
        .where('Status', isEqualTo: 'REJECTED')

        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        rejection = querySnapshot.size; // Count of documents in the query result
      });
    }).catchError((error) {
      print('Error fetching pending complaints: $error');
    });

    complaintsCollection
        .where('Status', isEqualTo: 'ACKNOWLEDGED')

        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
      acknowledged = querySnapshot.size; // Count of documents in the query result
      });
    }).catchError((error) {
      print('Error fetching pending complaints: $error');
    });

   complaintsCollection.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        totalcompalins = querySnapshot.size; // Count of documents in the collection
      });
    }).catchError((error) {
      print('Error fetching user collection: $error');
    });

    final UsersCollection =
    FirebaseFirestore.instance.collection('Users');

    // Query Firestore for pending complaints within the current month
    final userCollection = FirebaseFirestore.instance.collection('Users');

    // Query Firestore to get all documents in the 'Users' collection
    userCollection.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        userCount = querySnapshot.size; // Count of documents in the collection
      });
    }).catchError((error) {
      print('Error fetching user collection: $error');
    });



  }


  Future<void> fetchDataFromFirestore() async {
    final CollectionReference _complaintsCollection =
    FirebaseFirestore.instance.collection('graphs');

    try {
      final QuerySnapshot querySnapshot = await _complaintsCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        chartData = querySnapshot.docs
            .map((document) {
          final month = document['month'] as int;
          final complaints = document['complains'] as int;
          return FlSpot(month.toDouble(), complaints.toDouble());
        })
            .toList();

        // Sort the chartData based on 'month' in ascending order
        chartData.sort((a, b) => a.x.compareTo(b.x));

        setState(() {
          // Update the chartData and rebuild the widget
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }





  @override
  Widget build(BuildContext context) {
    Color myColor = Colors.green; // Replace with your desired color
    double opacity = 0.2;
    double opacity2 = 0.4;
    double opacity3 = 0.9;
    double opacity4 = 0.6;
    Color semiTransparentColor = myColor.withOpacity(opacity);


    Color myColor2 = Colors.blue;
    Color myColor3 = Colors.red;//
    Color myColor4 = Colors.purple;// Replace with your desired color

    Color semiTransparentColor2 = myColor2.withOpacity(opacity2);

    Color semiTransparentColor3 = myColor3.withOpacity(opacity3);
    Color semiTransparentColor4 = myColor4.withOpacity(opacity4);
    double acknowledgedPercentage = (acknowledged / totalcompalins) * 100;
    double rejectedPercentage = (rejection / totalcompalins) * 100;




    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.15,


                      child: Image.asset("assets/shield.png")),
                  SizedBox(height: 3,),
                  Text("Drug Information System", style: TextStyle(

                    color: Colors.green,


                  ),)


                ],




              ),
            ),
            ListTile(
              title: Text('Complaints'),
              onTap: () {
                // Navigate to Complaints Page
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Complains()));
              },
            ),
            ListTile(
              title: Text('Feedback'),
              onTap: () {
                // Navigate to Feedback Page
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Feedbacks()));
              },
            ),
            ListTile(
              title: Text('Users'),
              onTap: () {
                // Navigate to Users Page
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => UserList()));
              },
            ),
            ListTile(
              title: Text('Anonymous Complaints'),
              onTap: () {
                // Navigate to Anonymous Complaints Page
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Anoums()));
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1, // 50% of the screen
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(4),
                child: LineChart(
                  LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
                    LineChartBarData(spots: chartData),
                  ]),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // 50% of the screen
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 8.0, right: 4, bottom: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                 Expanded(
                                    child: Container(
                                      color: Colors.green,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text("Total Feedbacks", style: GoogleFonts.kanit (
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,



                                            ),),
                                          ),
                                          SizedBox(
                                            height: 4,

                                          ),
                                          Column(
                                            children: [

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [

                                                  Text("$feedbackCount", style: GoogleFonts.josefinSans (
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,



                                                  ),), SizedBox(width: 8,),
                                                  Container(
                                                    width:  45,
                                                     height: 45,

                                                      child: Image.asset("assets/feedback.png"),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ]),




                                    ),
                                  ),
                                Expanded(
                                  child: Container(


                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text("Anonymous Complains", style: GoogleFonts.kanit (
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,



                                          ),),
                                        ),
                                        SizedBox(
                                          height: 4,

                                        ),
                                        Column(
                                          children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text("$anonymousFeedbackCount", style: GoogleFonts.anton (
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),), SizedBox(width: 8,),
                                                Container(
                                                  width:  45,
                                                  height: 45,

                                                  child: Image.asset("assets/security.png"),
                                                ),],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],



                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(

                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text("Pending Complains", style: GoogleFonts.kanit (
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,



                                          ),),
                                        ),
                                        SizedBox(
                                          height: 4,

                                        ),
                                        Column(
                                          children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text("$pendingComplaintsCount", style: GoogleFonts.anton (
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,



                                                ),), SizedBox(width: 8,),
                                                Container(
                                                  width:  45,
                                                  height: 45,

                                                  child: Image.asset("assets/expired.png"),
                                                ),




                                              ],




                                            )

                                          ],
                                        ),



                                      ],




                                    ),

                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text("Total Users", style: GoogleFonts.josefinSans (
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,



                                          ),),
                                        ),
                                        SizedBox(
                                          height: 4,

                                        ),
                                        Column(
                                          children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                Text("$userCount", style: GoogleFonts.josefinSans (
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,



                                                ),), SizedBox(width: 8,),
                                                Container(
                                                  width:  45,
                                                  height: 45,

                                                  child: Image.asset("assets/man.png"),
                                                ),




                                              ],




                                            )

                                          ],
                                        ),



                                      ],




                                    ),

                                  ),
                                ),


                              ],



                            ),
                          ),

                        ],





                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 8, bottom: 4),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircularPercentIndicator(
                                        radius: MediaQuery.of(context).size.width * 0.07,
                                        lineWidth: 10.0,
                                        percent: acknowledgedPercentage / 100.0,
                                        center: Text(
                                          "${acknowledgedPercentage.toStringAsFixed(2)}%",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                        progressColor: Colors.green,
                                        circularStrokeCap: CircularStrokeCap.round,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text("Acknowledged", style: GoogleFonts.lilitaOne(
                                      fontSize: 20



                                    ),),
                                  ],
                                ),
                                SizedBox(width: 30.0),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircularPercentIndicator(
                                        radius: MediaQuery.of(context).size.width * 0.07,
                                        lineWidth: 10.0,
                                        percent: rejectedPercentage / 100.0,
                                        center: Text(
                                          "${rejectedPercentage.toStringAsFixed(2)}%",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                        progressColor: Colors.orange,
                                        circularStrokeCap: CircularStrokeCap.round,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text("Rejected", style: GoogleFonts.lilitaOne(
                                        fontSize: 20



                                    ),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                    ),
                  ),
                )

                ,
              ],
            ),
          ),
        ],
      ),
    );
  }
}


