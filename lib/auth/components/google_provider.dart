import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:flutter/material.dart';

class SignInWithGoogleWidget extends StatelessWidget {
  const SignInWithGoogleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Sign in with Google');
        store.dispatch(SignInWithGoogle());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: 
          Image.asset(
            googleIcon,
            height: 30,
          ),
          ),
          Expanded(child: 
          const Text(
            'Google',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          ),
        ],
      ),
    );
  }
}