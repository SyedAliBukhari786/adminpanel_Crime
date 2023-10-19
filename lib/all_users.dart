import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profiles'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No user profiles found');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final userData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final userName = userData['Name'] ?? '';
              final userContact = userData['Contact'] ?? '';
              final userAddress = userData['Address'] ?? '';
              final userCity = userData['City'] ?? '';
              final userDateOfBirth = userData['Date_of_Birth'] ?? '';
              final idCardBackUri = userData['ID_CARD_BACK_SIDE'] as String?;
              final idCardFrontUri = userData['ID_CARD_FRONT_SIDE'] as String?;

              // Use the Image.network widget to display images from URIs with a specific size.
              final idCardBackImage = idCardBackUri != null
                  ? Container(
                      width: 300,
                      height: 300,
                      child: Image.network(
                        idCardBackUri, // Image URL
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : Container();
              final idCardFrontImage = idCardFrontUri != null
                  ? Container(
                      width: 300,
                      height: 300,
                      child: Image.network(
                        idCardFrontUri, // Image URL
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : Container();

              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('Name: $userName'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Contact: $userContact'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Address: $userAddress'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('City: $userCity'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Date of Birth: $userDateOfBirth'),
                      ],
                    ),
                    Center(
                      child: Row(
                        children: [
                          idCardFrontImage,
                          SizedBox(width: 10),
                          idCardBackImage,
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
