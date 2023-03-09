import 'signin.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'question.dart';
import '../utils.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignIn(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Container(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Text("Problems Progress", style: h3),
                SizedBox(height: 10),
                problemsProgress(),
                SizedBox(height: 30),
                allTopicsAccordion()
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
                  stat(Color(0xffDCFCE7), "Correct", 10),
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
    return (Accordion(
      children: List.generate(
          10,
          (int index) => (AccordionSection(
                leftIcon:
                    const Icon(Icons.insights_rounded, color: Colors.white),
                headerBackgroundColor: Colors.blue[300],
                header: Text('Recursion', style: h3),
                content: topicItem("awadaw wdas wad sad"),
                contentHorizontalPadding: 5,
                contentBorderWidth: 1,
              ))),
    ));
  }

  Widget topicItem(String subtitle) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text(subtitle, textAlign: TextAlign.start, style: TextStyle()),
          TextButton(
            child: Text("Take Quiz"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionPage(
                          question: Question(
                              id: 1,
                              imgUrl: 'assets/BlueberryWaffles.jpeg',
                              isImg: true,
                              question: "How many wood can a wood chuck chuck",
                              choices: [
                                "LOL I MEAN WHAT CAN I DO",
                                "LOL I MEAN WHAT CAN I DO",
                                "LOL I MEAN WHAT CAN I DO",
                                "LOL I MEAN WHAT CAN I DO"
                              ],
                              correct: 3),
                        )),
              );
            },
          )
        ]));
  }
}
