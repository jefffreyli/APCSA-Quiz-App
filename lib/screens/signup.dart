import 'package:flutter/material.dart';

import 'signin.dart';
import 'home.dart';

List userInfo = [];

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 500,
                      padding: EdgeInsets.all(20),
                      child: Column(children: [
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(50.0),
                        //     child: Image.asset("assets/bxsci-clubs-logo.png",
                        //         width: 120)),
                        const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Sign up for SciClubs',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF097969)),
                                textAlign: TextAlign.center)),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(children: [
                              buildField("Full Name"),
                              buildField("OSIS"),
                              buildField("Graduation Year"),
                              buildField("Email"),
                              buildField("Password"),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: SizedBox(
                                      width: 500,
                                      height: height,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor:
                                                const Color(0xFF097969)),
                                        onPressed: () {
                                          userInfo.clear();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Home(),
                                              ),
                                            );
                                          },
                                        child: const Text('Sign Up',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      )))
                            ])),
                        SizedBox(height: height / 4, width: width),
                        Container(
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
                                    builder: (context) => const SignIn(),
                                  ),
                                );
                              },
                              child: const Text(
                                  'Already have an account? Login here.',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                            )),
                      ]),
                    ),
                  ),
                ),
              )),
        ));
  }
}

Widget buildField(String info) {
  TextEditingController t1 = TextEditingController();

  return Container(
    margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
    height: 25,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
    ),
    child: TextFormField(
      controller: t1,
      decoration: InputDecoration.collapsed(
        hintText: '$info',
        hintStyle: const TextStyle(fontSize: 16.0),
      ),
      validator: (value) {
        userInfo.add(t1.text);
        print(userInfo);

        if (value!.isEmpty) {
          return 'Please enter your ${info.toLowerCase()}';
        }
        return null;
      },
    ),
  );
}