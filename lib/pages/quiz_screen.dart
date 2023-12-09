import 'package:flutter/material.dart';
import 'package:student/widgets/question_card.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A52D0),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
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
            const QuestionCard(),
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
