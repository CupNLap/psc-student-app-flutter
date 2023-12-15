import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/pages/result_screen.dart';
import 'package:student/provider/exam_provider.dart';
import 'package:student/widgets/ads/banner.dart';
import 'package:student/widgets/question_card.dart';

import '../model/exam.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.quizRef,
  });

  final DocumentReference? quizRef;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Exam? exam;
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();

    ExamProvider provider = Provider.of<ExamProvider>(context, listen: false);

    provider.getExam(widget.quizRef!.path).then((value) => {
          // inform the provider about the exam is started
          provider.examStarted(),
          // update the exam value
          setState(() => exam = value),
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleNextClick() {
    // Check if all questions have been answered
    if (currentQuestionIndex + 1 >= exam!.questions.length) {
      // All questions answered, show result screen
      // TODO - Make the routings more dynamic, and use named routes
      // TODO - Add results to the exam
      // Navigator.pushNamed(context, '/result');

      Provider.of<ExamProvider>(context, listen: false).examCompleted();

      Navigator.pop(context);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ResultsScreen()));
    } else {
      // Move to next question
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A52D0),
      body: exam == null
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    exam!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.02,
                      fontFamily: 'Kodchasan',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  const AdBanner(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: QuestionCard(questionIndex: currentQuestionIndex),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => _handleNextClick(),
                    child: const Text("Next Question"),
                  )
                ],
              ),
            ),
    );
  }
}
