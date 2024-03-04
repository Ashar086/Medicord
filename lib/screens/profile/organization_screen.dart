import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class OrganizationScreen extends StatefulWidget {
  
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {

  @override
  Widget build(BuildContext context) {
      
      final User user = FirebaseAuth.instance.currentUser!;

    String photoUrl = user.photoURL ?? defaultProfileImage;
    String displayName = user.displayName ?? 'No Name';
    String email = user.email ?? 'No Email';
    return 
StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(photoUrl),
              radius: 50.0, // Size of the profile image
            ),
            SizedBox(height: 10), // Spacing between elements
            Text(
              displayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5), // Spacing between elements
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Expanded(child: SizedBox(),),
          ]
        ),
    );

        }
    );
  }
}