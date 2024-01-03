import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/model/question.dart';
import 'package:student/monetization/google_admob/banners.dart';

import 'package:student/provider/exam_provider.dart';

import '../model/exam.dart';
import '../widgets/exam/question/question_item.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({
    super.key,
    required this.examRef,
  });

  final DocumentReference? examRef;

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
    return Scaffold(
      body: exam == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MyStickyHeaderDelegate(
                    minHeight: 100.0,
                    maxHeight: 150.0,
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(exam!.name,
                                style: const TextStyle(fontSize: 24.0)),
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
                              selectedOption: exam!.questions[index].options[3],
                              showAnswers: true,
                              // onOptionSelected: (option) {
                              //   // setState(() => exam!
                              //   //     .questions[index].selectedOption = option);
                              // },
                            ),
                        childCount: exam!.questions.length)),
                SliverToBoxAdapter(
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Submit the Exam"))),
              ],
            )),
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
