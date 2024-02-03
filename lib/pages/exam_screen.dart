import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/exam.dart';
import '../monetization/google_admob/banners.dart';
import '../provider/exam_provider.dart';
import '../widgets/exam/question/question_item.dart';
import '../widgets/exam/timer.dart';
import '../widgets/utils/restrict_pop.dart';
import 'result_screen.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({
    super.key,
    required this.examRef,
    this.time,
  });

  final DocumentReference? examRef;
  final int? time;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  Exam? exam;
  int currentQuestionIndex = 0;
  late final ExamProvider _examProvider;

  @override
  void initState() {
    super.initState();

    _examProvider = Provider.of<ExamProvider>(context, listen: false);

    _examProvider.getExam(widget.examRef!.path).then((value) => {
          // inform the provider about the exam is started
          _examProvider.examStarted(),
          // update the exam value
          setState(() => exam = value),
        });
  }

  @override
  Widget build(BuildContext context) {
    return RestrictPop(
      title: "You can't leave exam before completion",
      content: "Please make sure that you have completed the exam before leaving it.",
      negativeActionText: "OK",
      positiveActionText: "Continue",
      child: Scaffold(
        body: exam == null
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: CustomScrollView(
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
                              Text(exam!.name,
                                  style: const TextStyle(fontSize: 24.0)),
                              TimerWidget(
                                  // Get the time from Parent widget, If there is no time available then set it to 75% of length of the exam as minutes
                                  minutes: widget.time ??
                                      exam!.questions.length * 0.75 ~/ 1,
                                  onTimerOver: () {
                                    _handleExamSubmit();
                                  }),
                              const GoogleBannerAd(),
                              Text(exam!.code,
                                  style: const TextStyle(fontSize: 12.0)),
                            ]),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) => QuestionView(
                                exam!.questions[index],
                                title: 'Question - ${index + 1}',
                                selectedOption: _examProvider
                                    .getSelectedOptionAtIndex(index),
                                onOptionSelected: (option) {
                                  _examProvider.setTheSelectedOptionAtIndex(
                                      index, option);
                                },
                                selectOptionsOnlyOnce: true,
                                // showAnswers: true,
                              ),
                          childCount: exam!.questions.length)),
                  SliverToBoxAdapter(
                      child: ElevatedButton(
                          onPressed: _handleExamSubmit,
                          child: const Text("Submit the Exam"))),
                ],
              )),
      ),
    );
  }

  void _handleExamSubmit() {
    _examProvider.examCompleted();

    Navigator.pop(context);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ResultsScreen()));
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
