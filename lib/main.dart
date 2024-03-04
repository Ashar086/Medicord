import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:brainmri/store/app_store.dart';

import 'constants/extensions.dart';
import 'screens/splash/splash_screen.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


const Color themeColor = Color(0xff00bc56);

String? packageVersion;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primarySwatch: themeColor.swatch,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: themeColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GlobalState>(
      store: store,
      child: 
    MaterialApp(
      onGenerateTitle: (context) => 'BrAIn MRI',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const SplashScreen(),
      builder: (BuildContext c, Widget? w) {
        return ScrollConfiguration(
          behavior: const NoGlowScrollBehavior(),
          child: w!,
        );
      },
    ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}


Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
}