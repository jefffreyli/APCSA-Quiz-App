import 'package:flutter/material.dart';

import 'signup.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

var db;

class _SignInState extends State<SignIn> {
  @override
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.9;
    var height = MediaQuery.of(context).size.height * 0.07;
    TextEditingController t1 = TextEditingController();
    TextEditingController t2 = TextEditingController();
    return MaterialApp(
      title: 'Login and Sign Up',
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
              child: Container(
            width: 500,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ClipRRect(
                  //     borderRadius: BorderRadius.circular(50.0),
                  //     child: Image.asset("assets/bxsci-clubs-logo.png",
                  //         width: 120)),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: const Text('Sign in to SciClubs',
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF097969)),
                          textAlign: TextAlign.center)),
                  Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Color(0xFFF6F8FA),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        SizedBox(
                            height: height * 1.2,
                            child: TextFormField(
                                onTap: () {},
                                controller: t1,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'OSIS or Email',
                                  // hintText: 'Enter your OSIS or email',
                                ),
                                validator: (value) {})),
                        Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: SizedBox(
                                height: height * 1.2,
                                child: TextFormField(
                                  controller: t2,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'Password',
                                  ),
                                  obscureText: true,
                                  validator: (value) {},
                                ))),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                                width: 500,
                                height: height,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: const Color(0xFF097969)),
                                  onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Home()));
                                  },
                                  child: const Text('Sign in',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ))),
                      ])),
                  Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: 500,
                      height: height,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: const Text('New to Quizzler? Create an account.',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      )),
                ]),
          )),
        ),
      ),
    );
  }
}