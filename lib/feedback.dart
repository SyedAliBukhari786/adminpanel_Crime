import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Feedbacks extends StatefulWidget {
  const Feedbacks({Key? key}) : super(key: key);

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedbacks'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Feedback')
            .orderBy('Timestamp', descending: true) // Order by timestamp (latest first)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching data.
          }

          List<Widget> feedbackWidgets = [];

          for (QueryDocumentSnapshot feedback in snapshot.data!.docs) {
            String userId = feedback['Userid'];
            String feedbackText = feedback['Feedback'];

            feedbackWidgets.add(
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
                builder: (context, userDoc) {
                  if (!userDoc.hasData) {
                    return CircularProgressIndicator(); // Show loading indicator for user data.
                  }

                  String userName = userDoc.data!['Name'];
                  // Create a widget to display the feedback along with the user's name.
                  return ListTile(
                    title: Center(child: Text(userName)),
                    subtitle: Center(child: Text(feedbackText)),
                  );
                },
              ),
            );
          }

          return ListView(
            children: feedbackWidgets,
          );
        },
      ),
    );
  }
}
