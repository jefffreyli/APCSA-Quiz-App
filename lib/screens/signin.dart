import 'package:flutter/material.dart';
import '../fbhelper.dart';
import 'signup.dart';
import '../utils.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: Form(
        //     key: _formKey,
        body: Container(
            margin: EdgeInsets.all(25),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              heading(),
              const SizedBox(height: 50),
              textField(emailController, "Email"),
              const SizedBox(height: 25),
              textField(passwordController, "Password", isObscured: true),
              const SizedBox(height: 30),
              signInButton(),
              const SizedBox(height: 25),
              createNewAccountButon()
            ])));
  }

  Widget heading() {
    return Text('Quizzler',
        style:
            TextStyle(fontSize: 50.0, fontWeight: FontWeight.w700, color: blue),
        textAlign: TextAlign.center);
  }

  Widget textField(TextEditingController t, String type,
      {bool isObscured = false}) {
    return SizedBox(
        child: TextFormField(
      controller: t,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: type,
        // hintText: 'Enter your OSIS or email',
      ),
      obscureText: isObscured,
    ));
  }

  Widget signInButton() {
    return Container(
        width: 300,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: blue),
          onPressed: () {
            print("sign in button pressed");
            print(emailController.text);
            print(passwordController.text);
            fb.signInWithEmailAndPassword(
                emailController.text, passwordController.text);
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const Home(),
            //   ),
            // );
          },
          child: const Text('Sign in',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ));
  }

  Widget createNewAccountButon() {
    return Container(
        width: 300,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: blue,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignUp(),
              ),
            );
          },
          child: const Text('Create an account.',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ));
  }
}
