import 'package:flutter/material.dart';
import 'package:new_snake_game/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCiIMf_7YN6waQVCo030TIBRnkjssl701A",
    authDomain: "snakegame-f2092.firebaseapp.com",
    projectId: "snakegame-f2092",
    storageBucket: "snakegame-f2092.appspot.com",
    messagingSenderId: "271996972728",
    appId: "1:271996972728:web:ed17c67a48850e7aa10e4d",
    measurementId: "G-HRKMJ0L9V9"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnakeGame',

      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
     
      home: const HomePage(),
    );
  }
}

