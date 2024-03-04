import 'package:brainmri/auth/components/secure_storage.dart';
import 'package:brainmri/store/app_logs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignInService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  static Future<User?> registerOrganization(String name, String email, String password) async {
    try {
      // Register the new organization
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Save organization info in the realtime database
        DatabaseReference orgRef = _firebaseDatabase.ref().child('organizations').child(user.uid);
        await orgRef.set({
          'name': name,
          'email': email,
        });

        await _addOrganizationId(user.uid);

        return user;
      } else {
        return Future.error('An error occurred');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Future.error('The account already exists for that email.');
      }
      return Future.error('An error occurred');
    } catch (e) {
      return Future.error('An error occurred');
    }
  }

  static Future<User> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await _addOrganizationId(user.uid);
        await _getOrganizationId().then((value) {
          AppLog.log().i('Organization ID: $value');
        });
        return user;
      } else {
        return Future.error('An error occurred');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return Future.error('Wrong password provided for that user.');
      }
      return Future.error('An error occurred');
    } catch (e) {
      return Future.error('An error occurred');
    }
  }

  static Future<void> _addOrganizationId(String uuid) async {
    await StorageService.addNewItemToKeyChain('uuid', uuid);
  }

  static Future<String?> _getOrganizationId() async {
    return await StorageService.readItemsFromToKeyChain().then((value) {
      return value['uuid'];
    });
  }
}
