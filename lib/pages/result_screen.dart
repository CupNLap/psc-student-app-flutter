import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/model/exam.dart';
import 'package:student/provider/exam_provider.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ExamResult? result =
        Provider.of<ExamProvider>(context, listen: false).currentExamResult;

    final int totalMarks = result!.totalMarks;
    final double scoredMarks = result.markScored;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Marks: $totalMarks',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Scored Marks: $scoredMarks',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Percentage: ${(scoredMarks / totalMarks * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
