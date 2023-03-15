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
          var jit = doc['answers'];
          qs['${Uri.decodeFull(doc['code'])} + \n${doc['text']}'] = [jit];
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

  // List temp = [
  //   {
  //     'text':
  //         'Consider the following code segment. What is the last row of numbers printed when this code segment is executed?',
  //     'answers': {
  //       '45': false,
  //       '45 44 43 42 41': false,
  //       '44 45': false,
  //       '45 44': true,
  //       '41 42': false
  //     },
  //     'topic': '2D Array',
  //     'code':
  //         '%20int%5B%5D%5B%5D%20points%20%3D%20%7B%20%7B11%2C%2012%2C%2013%2C%2014%2C%2015%7D%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7B21%2C%2022%2C%2023%2C%2024%2C%2025%7D%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7B31%2C%2032%2C%2033%2C%2034%2C%2035%7D%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7B41%2C%2042%2C%2043%2C%2044%2C%2045%7D%7D%3B%0A%20for%20%28int%20row%20%3D%200%3B%20row%20%3C%20points.length%3B%20row%2B%2B%29%0A%20%7B%0A%20%20%20%20%20for%20%28int%20col%20%3D%20points%5B0%5D.length%20-%201%3B%20col%20%3E%3D%20row%3B%20col--%29%0A%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20System.out.print%28points%5Brow%5D%5Bcol%5D%20%2B%20%22%20%22%29%3B%0A%20%20%20%20%20%7D%0A%20%20%20%20%20System.out.println%28%29%3B%0A%7D'
  //   },
  //   {
  //     'text':
  //         'Consider the following class definition. Each object of the class Cat will store the cat’s name as name, the cat’s age as age, and the number of kittens the cat has as kittens. Which of the following code segments, found in a class other than Cat, can be used to create a cat that is 5 years old with no kittens?',
  //     'answers': {
  //       'III only': false,
  //       'I and III only': true,
  //       'II only': false,
  //       'I, II and III': false,
  //       'I only': false
  //     },
  //     'topic': 'Writing Classes',
  //     'code':
  //         'public%20class%20Cat%0A%7B%0A%20%20%20%20private%20String%20name%3B%0A%20%20%20%20private%20int%20age%3B%0A%20%20%20%20private%20int%20kittens%3B%0A%0A%20%20%20%20public%20Cat%28String%20n%2C%20int%20a%2C%20int%20k%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20name%20%3D%20n%3B%0A%20%20%20%20%20%20%20%20age%20%3D%20a%3B%0A%20%20%20%20%20%20%20%20kittens%20%3D%20k%3B%0A%20%20%20%20%7D%0A%20%20%20%20public%20Cat%28String%20n%2C%20int%20a%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20name%20%3D%20n%3B%0A%20%20%20%20%20%20%20%20age%20%3D%20a%3B%0A%20%20%20%20%20%20%20%20kittens%20%3D%200%3B%0A%20%20%20%20%7D%0A%20%20%20%20/%2A%20Other%20methods%20not%20shown%20%2A/%0A%7D%0A%0AI.%20%20%20Cat%20c%20%3D%20new%20Cat%28%22Sprinkles%22%2C%205%2C%200%29%3B%0AII.%20%20Cat%20c%20%3D%20new%20Cat%28%22Lucy%22%2C%200%2C%205%29%3B%0AIII.%20Cat%20c%20%3D%20new%20Cat%28%22Luna%22%2C%205%29%3B'
  //   },
  //   {
  //     'text':
  //         'Consider the following code segment. How many times is the string “Hi!” printed as a result of executing the code segment?',
  //     'answers': {'12': false, '8': false, '15': true, '10': false},
  //     'topic': 'Iteration',
  //     'code':
  //         'int%20i%20%3D%200%3B%0Awhile%20%28i%20%3C%3D%204%29%0A%7B%0A%20%20for%20%28int%20j%20%3D%200%3B%20j%20%3C%203%3B%20j%2B%2B%29%0A%20%20%7B%0A%20%20%20%20System.out.println%28%22Hi%21%22%29%3B%0A%20%20%7D%0A%20%20i%2B%2B%3B%0A%7D'
  //   },
  //   {
  //     'text':
  //         'Assume that nums has been created as an ArrayList object and it initially contains the following Integer values [0, 0, 4, 2, 5, 0, 3, 0]. What will nums contain as a result of executing numQuest?',
  //     'answers': {
  //       '[3, 5, 2, 4, 0, 0, 0, 0]': false,
  //       '[4, 2, 5, 3]': false,
  //       '[0, 4, 2, 5, 3]': true,
  //       '[0, 0, 0, 0, 4, 2, 5, 3]': false
  //     },
  //     'topic': 'ArrayList',
  //     'code':
  //         'ArrayList%3CInteger%3E%20list1%20%3D%20new%20ArrayList%3CInteger%3E%28%29%3B%0Aprivate%20ArrayList%3CInteger%3E%20nums%3B%0A%0A//%20precondition%3A%20nums.size%28%29%20%3E%200%3B%0A//%20nums%20contains%20Integer%20objects%0Apublic%20void%20numQuest%28%29%0A%7B%0A%20%20%20int%20k%20%3D%200%3B%0A%20%20%20Integer%20zero%20%3D%20new%20Integer%280%29%3B%0A%20%20%20while%20%28k%20%3C%20nums.size%28%29%29%0A%20%20%20%7B%0A%20%20%20%20%20%20if%20%28nums.get%28k%29.equals%28zero%29%29%0A%20%20%20%20%20%20%20%20%20nums.remove%28k%29%3B%0A%20%20%20%20%20%20k%2B%2B%3B%0A%20%20%20%7D%0A%7D'
  //   },
  //   {
  //     'text': 'How many times does the following code print a *?',
  //     'answers': {'20': true, '24': false, '40': false, '30': false},
  //     'topic': 'Iteration',
  //     'code':
  //         'for%20%28int%20i%20%3D%203%3B%20i%20%3C%208%3B%20i%2B%2B%29%0A%7B%0A%20%20%20%20for%20%28int%20y%20%3D%201%3B%20y%20%3C%205%3B%20y%2B%2B%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20System.out.print%28%22%2A%22%29%3B%0A%20%20%20%20%7D%0A%20%20%20%20System.out.println%28%29%3B%0A%7D'
  //   },
  //   {
  //     'text': 'What is printed when the code segment is executed?',
  //     'answers': {
  //       '11.5': false,
  //       '14.0': false,
  //       '10.0': true,
  //       '0.666666666666667': false,
  //       '9.0': false
  //     },
  //     'topic': 'Primitive Types',
  //     'code':
  //         'int%20a%20%3D%205%3B%0Aint%20b%20%3D%202%3B%0Adouble%20c%20%3D%203.0%3B%0ASystem.out.println%285%20%2B%20a%20/%20b%20%2A%20c%20-%201%29%3B'
  //   },
  //   {
  //     'text': 'What type should you use to record if it is raining or not?',
  //     'answers': {
  //       'boolean': true,
  //       'String': false,
  //       'int': false,
  //       'double': false
  //     },
  //     'topic': 'Primitive Types',
  //     'code': ''
  //   },
  //   {
  //     'text':
  //         'What is the value of n when this method stops calling itself (when it reaches the base case)?',
  //     'answers': {'0': false, '1': true, '2': false},
  //     'topic': 'Recursion',
  //     'code':
  //         'public%20static%20int%20product%28int%20n%29%0A%7B%0A%20%20%20if%28n%20%3D%3D%201%29%0A%20%20%20%20%20%20return%201%3B%0A%20%20%20else%0A%20%20%20%20%20%20return%20n%20%2A%20product%28n%20-%202%29%3B%0A%7D'
  //   },
  //   {
  //     'text': 'Under what condition will a merge sort execute faster?',
  //     'answers': {
  //       'It will always take the same amount of time to execute': true,
  //       'If the data is already sorted in descending order': false,
  //       'If the data is already sorted in ascending order': false
  //     },
  //     'topic': 'Recursion',
  //     'code': ''
  //   },
  //   {
  //     'text':
  //         'Consider the following code segment. What is printed as a result of executing the code segment?',
  //     'answers': {
  //       'First': false,
  //       'FirstThird': false,
  //       'Nothing is printed out.': false,
  //       'FirstSecond': true,
  //       'Third': false
  //     },
  //     'topic': 'Control Flow',
  //     'code':
  //         'int%20x%20%3D%2010%3B%0Aint%20y%20%3D%205%3B%0A%0Aif%20%28x%20%25%202%20%3D%3D%200%20%26%26%20y%20%25%202%20%3D%3D%200%20%7C%7C%20x%20%3E%20y%29%0A%7B%0A%20%20%20%20System.out.print%28%22First%20%22%29%3B%0A%0A%20%20%20%20if%20%28y%20%2A%202%20%3D%3D%20x%20%7C%7C%20y%20%3E%205%20%26%26%20x%20%3C%3D%2010%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20System.out.print%28%22Second%20%22%29%3B%0A%20%20%20%20%7D%0A%20%20%20%20else%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20System.out.print%28%22Third%20%22%29%3B%0A%20%20%20%20%7D%0A%7D'
  //   },
  //   {
  //     'text': 'What does the following code print out?',
  //     'answers': {
  //       '4 3': false,
  //       '7': true,
  //       '5': false,
  //       'Does not compile.': false,
  //       '2 3': false
  //     },
  //     'topic': 'Using Objects',
  //     'code':
  //         'public%20class%20MethodTrace%0A%7B%0A%20%20public%20int%20square%28int%20x%29%0A%20%20%7B%0A%20%20%20%20%20%20return%20x%2Ax%3B%0A%20%20%7D%0A%20%20public%20int%20divide%28int%20x%2C%20int%20y%29%0A%20%20%7B%0A%20%20%20%20%20%20%20%20return%20x/y%3B%0A%20%20%7D%0A%20%20public%20static%20void%20main%28String%5B%5D%20args%29%20%7B%0A%20%20%20%20%20%20MethodTrace%20traceObj%20%3D%20new%20MethodTrace%28%29%3B%0A%20%20%20%20%20%20System.out.println%28%20traceObj.square%282%29%20%2B%20traceObj.divide%286%2C2%29%20%29%3B%0A%20%20%7D%0A%20%7D'
  //   },
  //   {
  //     'text':
  //         'Which of the following lines of code, if located in a method in the same class as calculatePizzaBoxes, will compile without an error?',
  //     'answers': {
  //       'int result = calculatePizzaBoxes(45.0, 9);': false,
  //       'int result = calculatePizzaBoxes(45, 9.0);': false,
  //       'result = calculatePizzaBoxes(45, 9);': false,
  //       'double result = calculatePizzaBoxes(45, 9.0);': true,
  //       'double result = calculatePizzaBoxes(45.0, 9.0);': false
  //     },
  //     'topic': 'Using Objects',
  //     'code':
  //         'public%20double%20calculatePizzaBoxes%28int%20numOfPeople%2C%20double%20slicesPerBox%29%0A%7B%20/%2Aimplementation%20not%20shown%20%2A/%7D'
  //   },
  //   {
  //     'text':
  //         'Given that array is an array of integers and target is an integer value, which of the following best describes the conditions under which the following code segment will return true?',
  //     'answers': {
  //       'Whenever the last element in array is equal to target.': true,
  //       'Whenever only 1 element in array is equal to target.': false,
  //       'Whenever the first element in array is equal to target.': false,
  //       'Whenever array contains any element which equals target.': false
  //     },
  //     'topic': 'Array',
  //     'code':
  //         'boolean%20temp%20%3D%20false%3B%0Afor%20%28int%20val%20%3A%20array%29%0A%7B%0A%20%20temp%20%3D%20%28%20target%20%3D%3D%20val%20%29%3B%0A%7D%0Areturn%20temp%3B'
  //   },
  //   {
  //     'text': 'What will print when the following code executes?',
  //     'answers': {
  //       '[1, 2, 3, 4, 5]': false,
  //       '[1, 2, 4, 3, 5]': true,
  //       '[1, 4, 2, 3, 5]': false,
  //       '[1, 2, 4, 5]': false
  //     },
  //     'topic': 'ArrayList',
  //     'code':
  //         'ArrayList%3CInteger%3E%20list1%20%3D%20new%20ArrayList%3CInteger%3E%28%29%3B%0Alist1.add%281%29%3B%0Alist1.add%282%29%3B%0Alist1.add%283%29%3B%0Alist1.add%282%2C%204%29%3B%0Alist1.add%285%29%3B%0ASystem.out.println%28list1%29%3B'
  //   },
  //   {
  //     'text':
  //         'Given the following class definitions and a declaration of Book b = new Dictionary which of the following will cause a compile-time error?',
  //     'answers': {
  //       'b.getDefintion();': true,
  //       'b.getISBN();': false,
  //       '((Dictionary) b).getDefinition();': false
  //     },
  //     'topic': 'Inheritance',
  //     'code':
  //         'public%20class%20Book%0A%7B%0A%20%20%20public%20String%20getISBN%28%29%0A%20%20%20%7B%0A%20%20%20%20%20%20//%20implementation%20not%20shown%0A%20%20%20%7D%0A%0A%20%20%20//%20constructors%2C%20fields%2C%20and%20other%20methods%20not%20shown%0A%7D%0A%0Apublic%20class%20Dictionary%20extends%20Book%0A%7B%0A%20%20%20public%20String%20getDefinition%28%29%0A%20%20%20%7B%0A%20%20%20%20%20%20//%20implementation%20not%20shown%0A%20%20%20%7D%0A%7D'
  //   },
  //   {
  //     'text':
  //         'Given the following code segment what will be returned when you execute: getIndexOfLastElementSmallerThanTarget(values, 7);',
  //     'answers': {
  //       '-15': false,
  //       '-1': false,
  //       '1': true,
  //       'You will get an out of bounds error.': false
  //     },
  //     'topic': 'Array',
  //     'code':
  //         'private%20int%5B%20%5D%20values%20%3D%20%7B-20%2C%20-15%2C%202%2C%208%2C%2016%2C%2033%7D%3B%0A%0Apublic%20static%20int%20getIndexOfLastElementSmallerThanTarget%28int%5B%20%5D%20values%2C%20int%20compare%29%0A%7B%0A%20%20%20for%20%28int%20i%20%3D%20values.length%20-%201%3B%20i%20%3E%3D0%3B%20i--%29%0A%20%20%20%7B%0A%20%20%20%20%20%20if%20%28values%5Bi%5D%20%3C%20compare%29%0A%20%20%20%20%20%20%20%20%20return%20i%3B%0A%20%20%20%7D%0A%20%20%20return%20-1%3B%20//%20to%20show%20none%20found%0A%7D'
  //   },
  //   {
  //     'text': 'Consider the following code segment.',
  //     'answers': {
  //       'message.equals(note) && message.equals(memo)': false,
  //       'message == note && message == memo': false,
  //       'message == note && memo.equals(“Practice”)': true,
  //       'message.equals(memo) || memo.equals(note)': false,
  //       'message != note || message == memo': false
  //     },
  //     'topic': 'Control Flow',
  //     'code':
  //         'String%20message%20%3D%20new%20String%28%22AP%20Practice%22%29%3B%0AString%20note%20%3D%20new%20String%28%22AP%20Practice%22%29%3B%0AString%20memo%20%3D%20new%20String%28%22memo%22%29%3B%0Aint%20i%20%3D%205%3B%0A%0Aif%20%28message.equals%28note%29%20%26%26%20%21message.equals%28%22memo%22%29%29%0A%7B%0A%20%20%20%20message%20%3D%20note%3B%0A%0A%20%20%20%20if%20%28message%20%3D%3D%20note%20%26%26%20message.length%28%29%20%3E%20i%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20i%20%3D%203%3B%0A%20%20%20%20%20%20%20memo%20%3D%20message.substring%28i%29%3B%0A%20%20%20%20%7D%0A%7D'
  //   },
  //   {
  //     'text':
  //         'Consider the following Party class. The getNumOfPeople method is intended to allow methods in other classes to access a Party object’s numOfPeople instance variable value; however, it does not work as intended. Which of the following best explains why the getNumOfPeople method does NOT work as intended?',
  //     'answers': {
  //       'The instance variable num should be returned instead of numOfPeople, which is local to the constructor.':
  //           false,
  //       'The variable numOfPeople is not declared inside the getNumOfPeople method.':
  //           false,
  //       'The getNumOfPeople method should have at least one parameter.': false,
  //       'The return type of the getNumOfPeople method should be void.': false,
  //       'The getNumOfPeople method should be declared as public.': true
  //     },
  //     'topic': 'Writing Classes',
  //     'code':
  //         'public%20class%20Party%0A%7B%0A%20%20%20%20private%20int%20numOfPeople%3B%0A%0A%20%20%20%20public%20Party%28int%20num%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20numOfPeople%20%3D%20num%3B%0A%20%20%20%20%7D%0A%0A%20%20%20%20private%20int%20getNumOfPeople%28%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20return%20numOfPeople%3B%0A%20%20%20%20%7D%0A%7D'
  //   },
  //   {
  //     'text':
  //         'Consider the following code segment. What is the value of sum as a result of executing the code segment?',
  //     'answers': {
  //       '54': true,
  //       '63': false,
  //       '78': false,
  //       '68': false,
  //       '36': false
  //     },
  //     'topic': '2D Array',
  //     'code':
  //         'int%5B%5D%5B%5D%20arr%20%3D%20%7B%20%7B1%2C%202%2C%203%2C%204%7D%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7B5%2C%206%2C%207%2C%208%7D%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7B9%2C%2010%2C%2011%2C%2012%7D%20%7D%3B%0Aint%20sum%20%3D%200%3B%0Afor%20%28int%5B%5D%20x%20%3A%20arr%29%0A%7B%0A%20%20%20%20for%20%28int%20y%20%3D%200%3B%20y%20%3C%20x.length%20-%201%3B%20y%2B%2B%29%0A%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20sum%20%2B%3D%20x%5By%5D%3B%0A%20%20%20%20%7D%0A%7D'
  //   },
  //   {
  //     'text':
  //         'Which of the following declarations in Student would correctly override the getFood method in Person?',
  //     'answers': {
  //       'public String getFood()': true,
  //       'public void getFood()': false,
  //       'public String getFood(int quantity)': false
  //     },
  //     'topic': 'Inheritance',
  //     'code':
  //         'public%20class%20Person%0A%7B%0A%20%20%20private%20String%20name%20%3D%20null%3B%0A%0A%20%20%20public%20Person%28String%20theName%29%0A%20%20%20%7B%0A%20%20%20%20%20%20name%20%3D%20theName%3B%0A%20%20%20%7D%0A%0A%20%20%20public%20String%20getFood%28%29%0A%20%20%20%7B%0A%20%20%20%20%20%20return%20%22Hamburger%22%3B%0A%20%20%20%7D%0A%7D%0A%0Apublic%20class%20Student%20extends%20Person%0A%7B%0A%20%20%20private%20int%20id%3B%0A%20%20%20private%20static%20int%20nextId%20%3D%200%3B%0A%0A%20%20%20public%20Student%28String%20theName%29%0A%20%20%20%7B%0A%20%20%20%20%20super%28theName%29%3B%0A%20%20%20%20%20id%20%3D%20nextId%3B%0A%20%20%20%20%20nextId%2B%2B%3B%0A%20%20%20%7D%0A%0A%20%20%20public%20int%20getId%28%29%20%7Breturn%20id%3B%7D%0A%0A%20%20%20public%20void%20setId%20%28int%20theId%29%0A%20%20%20%7B%0A%20%20%20%20%20%20this.id%20%3D%20theId%3B%0A%20%20%20%7D%0A%7D'
  //   },
  // ];
}
