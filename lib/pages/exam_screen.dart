import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gobal/crash_consts.dart';
import '../model/exam.dart';
import '../monetization/google_admob/banners.dart';
import '../provider/exam_provider.dart';
import '../widgets/exam/question/question_item.dart';
import '../widgets/exam/timer.dart';
import '../widgets/utils/gap.dart';
import 'result_screen.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({
    super.key,
    required this.examRef,
    this.time,
  });

  final DocumentReference examRef;
  final int? time;

  @override
  Widget build(BuildContext context) {
    logPageName('exam_screen.dart');
    late final ExamProvider _examProvider;

    _examProvider = Provider.of<ExamProvider>(context, listen: false);

    void _handleExamSubmit() {
      _examProvider.examCompleted();
      _examProvider.saveExamResultInFirestore();

      Navigator.pop(context);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ResultsScreen()));
    }

    CustomScrollView ExamView(Exam exam) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: MyStickyHeaderDelegate(
              minHeight: 150.0,
              maxHeight: 250.0,
              child: Container(
                color: Colors.grey[200],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(exam.name, style: const TextStyle(fontSize: 24.0)),
                      TimerWidget(
                          // Get the time from Parent widget, If there is no time available then set it to 75% of length of the exam as minutes
                          minutes: time ?? exam.questions.length * 0.75 ~/ 1,
                          onTimerOver: () {
                            _handleExamSubmit();
                          }),
                      GoogleBannerAd('ca-app-pub-3032031918447892/3252184339'),
                      Text(exam.code, style: const TextStyle(fontSize: 12.0)),
                    ]),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => QuestionView(
                        exam.questions[index],
                        title: 'Question - ${index + 1}',
                        selectedOption:
                            _examProvider.getSelectedOptionAtIndex(index),
                        onOptionSelected: (option) {
                          _examProvider.setTheSelectedOptionAtIndex(
                              index, option);
                        },
                        selectOptionsOnlyOnce: true,
                        // showAnswers: true,
                      ),
                  childCount: exam.questions.length)),
          SliverToBoxAdapter(
              child: ElevatedButton(
                  onPressed: _handleExamSubmit,
                  child: const Text("Submit the Exam"))),
        ],
      );
    }

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Exam>>(
        future: examRef
            .withConverter(
              fromFirestore: (snapshot, _) => Exam.fromFirestore(snapshot),
              toFirestore: (exam, _) => exam.toFirestore(),
            )
            .get(
              GetOptions(source: Source.server),
            ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error occured ${snapshot.error.toString()}"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Gap(),
                  Text('Loading Exam'),
                ],
              ),
            );
          }

          final exam = snapshot.data!.data();
          if (exam == null) {
            return Center(child: Text("No Exam Found"));
          }

          // Record that the exam has started
          _examProvider.examStarted(exam, examRef.path);
          SharedPreferences.getInstance().then((pref) {
            pref.setBool('${examRef.path}', false);
          });

          return SafeArea(child: ExamView(exam));
        },
      ),
    );
  }
}

class MyStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  MyStickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(MyStickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
