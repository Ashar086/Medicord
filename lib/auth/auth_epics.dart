import 'dart:async';
import 'package:brainmri/auth/firebase_auth_service.dart';
import 'package:brainmri/auth/signin/signin_service.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/error_reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


Stream<dynamic> googleAuthEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SignInWithGoogle) 
      .asyncMap((action) => FirebaseAuthService.signInWithGoogle())
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SignInWithGoogleSuccessAction(value),
          ]),)
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while signing in with google'),
          ]),);
}

Stream<dynamic> signInWithEmailEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is LoginAction)
      .asyncMap((action) => SignInService.signIn(action.email, action.password))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            LoginSuccessAction(value),
          ]),)
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while signing in with email'),
          ]),);
}

Stream<dynamic> signUpWithEmailEpic(Stream<dynamic> actions, EpicStore<GlobalState> store) {
  return actions
      .where((action) => action is SignUpAction)
      .asyncMap((action) => SignInService.registerOrganization(action.name, action.email, action.password))
      .flatMap<dynamic>((value) => Stream.fromIterable([
            SignUpResponseAction(value),
          ]),)
      .onErrorResume((error, stackTrace) => Stream.fromIterable([
            HandleGenericErrorAction('Error while signing up with email'),
          ]),);
}



List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<GlobalState>)> authEffects = [
  googleAuthEpic,
  signInWithEmailEpic,
  signUpWithEmailEpic,
];
