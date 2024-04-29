import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gobal/crash_consts.dart';
import '../model/exam.dart';
import '../monetization/google_admob/banners.dart';
import '../provider/exam_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/exam/question/question_card.dart';
import '../widgets/utils/gap.dart';
import 'result_screen.dart';

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
  late final ExamProvider _examProvider;

  @override
  void initState() {
    super.initState();

    logPageName('quiz_screen.dart');

    _examProvider = Provider.of<ExamProvider>(context, listen: false);

    _examProvider.getExam(widget.quizRef!.path).then((value) => {
          // inform the provider about the exam is started
          _examProvider.examStarted(),
          // update the exam value
          setState(() => exam = value),
        });
  }

  @override
  void dispose() {
    super.dispose();

    // TODO - handle this , record the user action in actions for results
  }

  void _handleNextClick() {
    // Check if all questions have been answered
    if (currentQuestionIndex + 1 >= exam!.questions.length) {
      // All questions answered, show result screen
      // TODO - Make the routings more dynamic, and use named routes
      // TODO - Add results to the exam
      // Navigator.pushNamed(context, '/result');

      _examProvider.examCompleted();

      Navigator.pop(context);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ResultsScreen()));
    } else {
      // Move to next question
      _examProvider.movingToNextQuestion(
          currentQuestionIndex, currentQuestionIndex++);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A52D0),
      body: exam == null
          ? Container()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Gap(AppTheme.smallGutter),
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
                    GoogleBannerAd('ca-app-pub-3032031918447892/5686775981'),
                    Gap(AppTheme.largeGutter),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: QuestionCard(questionIndex: currentQuestionIndex),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(AppTheme.largeGutter),
          GoogleBannerAd('ca-app-pub-3032031918447892/5686775981'),
          Gap(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            onPressed: () => _handleNextClick(),
            child: const Text("Next Question"),
          ),
          Gap(),
        ],
      ),
    );
  }
}
