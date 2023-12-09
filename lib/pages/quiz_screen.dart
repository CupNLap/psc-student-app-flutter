import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/widgets/ads/banner.dart';
import 'package:student/widgets/question_card.dart';

import 'package:student/model/question.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({
    super.key,
    this.quizRef,
  });

  final DocumentReference<Object?>? quizRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A52D0),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Math Test 502',
              textAlign: TextAlign.center,
              style: TextStyle(
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
              child: QuestionCard(
                Question(
                  text: 'text There is no right answer found for this question in options There is no right answer found for this question There is no right answer found for this question in optionsin options text There is no right answer found for this question in options There is no right answer found for this question There is no right answer found for this question in optionsin options?',
                  options: {
                    'options1',
                    'options2',
                    'options3',
                    'options4',
                  },
                  answer: 'options1',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () {},
              child: const Text("Next Question"),
            )
          ],
        ),
      ),
    );
  }
}
