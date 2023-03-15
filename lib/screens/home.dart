import 'signin.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'question.dart';
import '../utils.dart';
import '../fbhelper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

late List all;
int questionNumber = 0;

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home"), backgroundColor: blue,),
        body: Container(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Text("Problems Progress", style: h3),
                SizedBox(height: 10),
                problemsProgress(),
                SizedBox(height: 30),
                allTopicsAccordion(),
                signOutButton()
              ],
            ))));
  }

  Widget problemsProgress() {
    return Card(
        elevation: 4,
        child: (Container(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  stat(green, "Correct", 10),
                  stat(Colors.red[200], "Incorrect", 1),
                  stat(Color(0xffFFF9C3), "Not Started", 30),
                  stat(Color(0xffF3F4F6), "Overall", 50)
                ],
              )
            ]))));
  }

  Widget stat(Color? color, String label, int n) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(backgroundColor: color, radius: 30),
            Text(
              n.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget allTopicsAccordion() {
    List topicsList = [
      "Primitive Types",
      "Using Objects",
      "Control Flow",
      "Iteration",
      "Classes",
      "Array",
      "ArrayList",
      "2D Array",
      "Inheritance",
      "Recursion"
    ];

    return (Accordion(
      children: List.generate(
          10,
          (int index) => (AccordionSection(
                leftIcon:
                    const Icon(Icons.insights_rounded, color: Colors.white),
                headerBackgroundColor: blue,
                header: Text(topicsList[index], style: h2),
                content: topicItem(topicsList[index]),
                contentHorizontalPadding: 5,
                contentBorderWidth: 1,
                contentBorderColor: blue,
              ))),
    ));
  }

  Widget topicItem(String subtitle) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text(subtitle, textAlign: TextAlign.start, style: TextStyle(color: Colors.blueGrey[400])),
          TextButton(
            child: Text("Take Quiz", style: TextStyle(color: blue)),
            onPressed: () async {
              Map<String, List> qs = await fb.getQuestions(subtitle);
              all = buildQuestionList(qs);
              print(all[questionNumber]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuestionPage(question: all[questionNumber]),
                  ));
            },
          )
        ]));
  }

  List buildQuestionList(Map qs) {
    List q = [];
    qs.forEach((key, value) {
      List choices = [];
      value[0].forEach((k, v) => choices.add(k));
      q.add(Question(
          choices: choices,
          imgUrl: 'assets/BlueberryWaffles.jpeg',
          isImg: false,
          id: 1,
          question: key,
          correct: checkCorrect(value).toString()));
    });
    return q;
  }

  int checkCorrect(List compsci) {
    int index = 0;
    bool lol = false;
    compsci[0].forEach((key, value) {
      if (value == true) {
        lol = true;
      }
      if (lol == false && value == false) {
        index += 1;
      }
    });
    return index;
  }

  Widget signOutButton() {
    return ElevatedButton(
        child: Text("Sign Out"),
        onPressed: () {
          fb.signOut();
        });
  }
}
