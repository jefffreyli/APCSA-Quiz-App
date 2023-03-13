import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final usersCollection = FirebaseFirestore.instance.collection('users');
final db = FirebaseFirestore.instance;
var firebaseUser = FirebaseAuth.instance.currentUser!;

bool isLoggedIn = false;
bool hasSignedUp = false;
Map<String, dynamic> userData = {};
String eMAIL = "";
String docID = "";
Map questions = {};

class fbHelper {
  fbHelper();
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      eMAIL = email;
      hasSignedUp = true;
      print("Signed Up");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getQuestions(String topic) async {
    List qs = [];
    db.collection("questions").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          qs.add(docSnapshot.data());
          print(docSnapshot.data());
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Signed in");
      eMAIL = email;

      isLoggedIn = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("Signed out");
  }
}
