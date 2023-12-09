import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/widgets/ads/banner.dart';
import 'package:student/widgets/question_card.dart';

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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: QuestionCard(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () {},
              child: Text("Next Question"),
            )
          ],
        ),
      ),
    );
  }
}
