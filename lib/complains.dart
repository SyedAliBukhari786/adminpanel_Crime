import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Complains extends StatefulWidget {
  const Complains({Key? key}) : super(key: key);

  @override
  State<Complains> createState() => _ComplainsState();
}

class _ComplainsState extends State<Complains> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Complains')
            .where('Status', isEqualTo: 'PENDING')
           // .orderBy('Timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final complaints = snapshot.data!.docs;

            return ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final data = complaints[index].data() as Map<String, dynamic>;
                final timestamp = data['Timestamp'] as Timestamp;
                final formattedTimestamp = _formatTimestamp(timestamp);

                // Access the User's data
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('Users').doc(data['Userid']).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.done) {
                      final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      final userName = userData['Name'];
                      final userContact = userData['Contact'];

                      // Get the document ID of the complaint
                      final documentId = complaints[index].id;

                      return Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Container(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text('Area: ${data['Area']}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complaint:  ${data['Complaindescriprtion']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Status: ${data['Status']}'),
                                  Text('Timestamp: $formattedTimestamp'),
                                  Text('UserID: ${data['Userid']}'),
                                  Text('User Name: $userName'), // Display User's Name
                                  Text('User Contact: $userContact'), // Display User's Contact
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        height: MediaQuery.of(context).size.height * 0.3,
                                       // color: Colors.red,
                                        child: Image.network(userData['ID_CARD_FRONT_SIDE']), // Load front side image
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        height: MediaQuery.of(context).size.height * 0.3,
                                       // color: Colors.blue,
                                        child: Image.network(userData['ID_CARD_BACK_SIDE']), // Load back side image
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.14,
                                          height: 45,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _updateStatus(documentId, "REJECTED");
                                            },
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.14,
                                          height: 45,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _updateStatus(documentId, "ACKNOWLEDGED");
                                            },
                                            child: Text(
                                              "Acknowledged",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return CircularProgressIndicator(); // Loading indicator for user data
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _updateStatus(String documentId, String newStatus) {
    FirebaseFirestore.instance.collection('Complains').doc(documentId).update({
      'Status': newStatus,
    }).then((_) {
      // The status has been updated successfully.
      // You can add additional logic here if needed.
    }).catchError((error) {
      // Handle any errors that occurred during the update.
      print("Error updating status: $error");
    });
  }
}
