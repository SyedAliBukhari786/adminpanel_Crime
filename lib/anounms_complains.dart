import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Anoums extends StatefulWidget {
  const Anoums({Key? key}) : super(key: key);

  @override
  State<Anoums> createState() => _AnoumsState();
}

class _AnoumsState extends State<Anoums> {

  void _updateStatus(String documentId, String newStatus) {
    FirebaseFirestore.instance.collection('Anonymous').doc(documentId).update({
      'Status': newStatus,
    }).then((_) {
      // The status has been updated successfully.
      // You can add additional logic here if needed.
    }).catchError((error) {
      // Handle any errors that occurred during the update.
      print("Error updating status: $error");
    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Anonymous')
                .where('Status', isEqualTo: 'PENDING')
              //  .orderBy('Timestamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final complaints = snapshot.data!.docs;

                return  ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final document = complaints[index];
                    final data = document.data() as Map<String, dynamic>;
                    final timestamp = data['Timestamp'] as Timestamp;
                    final formattedTimestamp = _formatTimestamp(timestamp);

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
                                            _updateStatus(document.id, "REJECTED");
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
                                            _updateStatus(document.id, "ACKNOWLEDGED");
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
}
