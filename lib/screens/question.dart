import 'package:flutter/material.dart';
import 'package:apcsa_quiz/utils.dart';
import 'package:apcsa_quiz/fbhelper.dart';

class QuestionPage extends StatefulWidget {
  final Question question;
  const QuestionPage({super.key, required this.question});

  @override
  State<QuestionPage> createState() => _QuestionPage();
}

class _QuestionPage extends State<QuestionPage> {
  bool isVisible = false;
  bool isCorrect = false;
  List colors = [
    Colors.blue[300],
    Colors.blue[300],
    Colors.blue[300],
    Colors.blue[300]
  ];

  Widget createButtons() {
    List<Widget> column = List.generate(widget.question.choices.length,
        (index) => buildOption(context, index, Icons.add));
    return Column(children: column);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Container(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                buildQuestion(context),
                createButtons()
              ],
            ))),
        floatingActionButton: isVisible
            ? FloatingActionButton.extended(
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: const Text('Correct, Move on'),
                icon: const Icon(Icons.thumb_up))
            : null);
  }

  Widget buildQuestion(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return widget.question.isImg
        ? Container(
            height: height / 2,
            width: width,
            child: Image.asset(widget.question.imgUrl))
        : Container(
            height: height / 2,
            child: Text(
                widget.question.question,
                style: h3));
  }

  Widget buildOption(BuildContext context, int index, IconData icon) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: colors[index],
            ),
            onPressed: () {
              setState(() {
                if (widget.question.correct == index.toString()) {
                  isVisible = true;
                  isCorrect = true;
                  showAlertDialog(context, index);
                } else {
                  colors[index] = Colors.red[200];
                  showAlertDialog(context, index);
                }
              });
            },
            child: ListTile(
                leading: Icon(icon),
                title: Text(widget.question.choices[index].toString(),
                    style: h3, maxLines: 2))));
  }

  showAlertDialog(BuildContext context, int index) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: isCorrect
          ? const Text("That was the Correct Answer!")
          : const Text('Wrong Answer!'),
      content: isCorrect
          ? Text(
              'You choose ${widget.question.choices[index]}\nThe explanation is: Gang Whole lotta Ben')
          : Text("You choose the wrong answer. The answer was option."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Question {
  String imgUrl;
  bool isImg;
  String question;
  List choices;
  String correct;
  int id;

  Question(
      {required this.id,
      required this.imgUrl,
      required this.isImg,
      required this.question,
      required this.choices,
      required this.correct});
}
