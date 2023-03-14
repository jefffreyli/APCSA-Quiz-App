import 'package:flutter/material.dart';

import 'signin.dart';
import '../utils.dart';
import '../fbHelper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.all(25),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              heading(),
              const SizedBox(height: 50),
              buildField(nameController, "Full Name"),
              const SizedBox(height: 15),
              buildField(emailController, "Email"),
              const SizedBox(height: 15),
              buildField(passwordController, "Password"),
              const SizedBox(height: 30),
              signUpButton(),
              const SizedBox(height: 15),
              signInButton()
            ])));
  }

  Widget heading() {
    return Text('Sign up for Quizzler',
        style:
            TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700, color: blue),
        textAlign: TextAlign.center);
  }

  Widget signUpButton() {
    return Container(
        height: 40,
        width: 300,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: blue),
          onPressed: () {
            fb.createUserWithEmailAndPassword(
                emailController.text, passwordController.text);
          },
          child: const Text('Sign Up',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ));
  }

  Widget signInButton() {
    return Container(
        width: 300,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignIn(),
              ),
            );
          },
          child: const Text('Already have an account? Login here.',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
        ));
  }

  Widget buildField(TextEditingController t, String info) {
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
        controller: t,
        decoration: InputDecoration.collapsed(
          hintText: '$info',
          hintStyle: const TextStyle(fontSize: 16.0),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your ${info.toLowerCase()}';
          }
          return null;
        },
      ),
    );
  }
}
