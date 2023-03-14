import 'package:apcsa_quiz/screens/home.dart';
import 'package:apcsa_quiz/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Home();
              } else {
                return SignIn();
              }
            })
        // FutureBuilder(
        //   future: FirebaseAuth.instance.authStateChanges().first,
        //   builder: (context, AsyncSnapshot<User?> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     if (snapshot.hasData) {
        //       // User is already signed in, so route to home page.
        //       return Home();
        //     } else {
        //       // User is not signed in, so route to sign-in page.
        //       return SignIn();
        //     }
        //   },
        // ),
        );
  }
}
