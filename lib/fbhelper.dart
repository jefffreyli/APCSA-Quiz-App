import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;

Map<String, dynamic> userData = {};
String docID = "";
Map questions = {};

fbHelper fb = new fbHelper();

class fbHelper {
  fbHelper();

  Future<Map<String, List>> getQuestions(String topic) async {
    Map<String, List> qs = {};
    await db
        .collection("questions")
        .where("topic", isEqualTo: topic)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var doc = docSnapshot.data();
          qs[doc['question']] = [
            doc['choice_1'],
            doc['choice_2'],
            doc['choice_3'],
            doc['choice_4'],
            doc['correct_choice']
          ];
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return qs;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("Signed out");
  }
}
