import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final usersCollection = FirebaseFirestore.instance.collection('users');
FirebaseFirestore firestore = FirebaseFirestore.instance;
var firebaseUser = FirebaseAuth.instance.currentUser!;

bool isLoggedIn = false;
bool hasSignedUp = false;
Map<String, dynamic> userData = {};
String eMAIL = "";
String docID = "";
Map questions = {};

class fbHelper {
  fbHelper();

  // Future<void> addUser(String full_name, String osis, String official_class,
  //     String graduation_year, String bxscience_email, String password) {
  //   // Call the user's CollectionReference to add a new user

  //   return usersCollection
  //       .add({
  //         'full_name': full_name,
  //         'osis': osis,
  //         'official_class': official_class,
  //         'graduation_year': graduation_year,
  //         'bxscience_email': bxscience_email,
  //         'password': password,
  //         'clubs': {},
  //         'user_type': "Member",
  //         'about_me': "About me."
  //       })
  //       .then(
  //           (value) => {docID = value.id, print("User Added with ID: $docID")})
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  Future<void> addUser(String full_name, String osis, String official_class,
      String graduation_year, String bxscience_email, String password) async {
    // Call the user's CollectionReference to add a new user
    eMAIL = bxscience_email;

    try {
      var docRef = await usersCollection.add({
        'full_name': full_name,
        'osis': osis,
        'official_class': official_class,
        'graduation_year': graduation_year,
        'bxscience_email': bxscience_email,
        'password': password,
        'clubs': {},
        'user_type': "Member",
        'about_me': "About me"
      });
      docID = docRef.id;
      print("User Added with ID: $docID");
      await getUserData();
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // try {
    //   final FirebaseAuth auth = FirebaseAuth.instance;
    //   await auth.createUserWithEmailAndPassword(email: email, password: password);
    //   print("Signed up");
    //   eMAIL = email;
    //   hasSignedUp = true;
    // } on FirebaseAuthException catch (e) {}

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

  Future<void> getUserData() async {
    QuerySnapshot snapshot =
        await usersCollection.where('bxscience_email', isEqualTo: eMAIL).get();
    if (snapshot.size > 0) {
      docID = snapshot.docs.first.id;
    }

    DocumentSnapshot document = await usersCollection.doc(docID).get();
    userData = document.data() as Map<String, dynamic>;
  }

  Future<void> getQuestions(String topic) async {
    List tit = [];
    firestore
        .collection("question")
        .where('topic', isEqualTo: topic)
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          tit.add(docSnapshot.data());
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    questions[topic] = tit;
  }

  Future<void> updateAboutMe(String aboutMe) async {
    userData['about_me'] = aboutMe;

    //find a way to get the docID for the user (this is just lij12@bxscience.edu's id)
    usersCollection
        .doc(docID)
        .update({'about_me': userData['about_me']})
        .then((value) => print("About me added."))
        .catchError((error) => print("Failed to add about me: $error"));
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Signed in");
      eMAIL = email;

      getUserData();

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
