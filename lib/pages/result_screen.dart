import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/model/exam.dart';
import 'package:student/model/question.dart';
import 'package:student/provider/exam_provider.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ExamProvider provider = Provider.of<ExamProvider>(context, listen: false);
    ExamResult? result = provider.currentExamResult;
    Map<String, List<Question>> analysis = provider.getResponseAnalysis();
    provider.reset();

    final int totalMarks = result!.totalMarks;
    final double scoredMarks = result.markScored;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Total Marks: $totalMarks',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Scored Marks: $scoredMarks',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Percentage: ${(scoredMarks / totalMarks * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 20),
            ),
            _buildQuestionListByType(
                "Currect Answers", analysis['correctAnswers']!),
            _buildQuestionListByType(
                "Wrong Answers", analysis['wrongAnswers']!),
            _buildQuestionListByType(
                "Skipped Questions", analysis['skippedQuestions']!),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionListByType(String header, List<Question> questions) {
    if (questions.isEmpty) {
      return const SizedBox();
    }
    return Column(children: [
      const SizedBox(height: 20),
      Text(header, style: const TextStyle(fontSize: 24)),
      ...questions.map((question) => _buildQuestionItem(question)).toList(),
    ]);
  }

  Widget _buildQuestionItem(Question question) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            _buildOptionList(
                question.options, question.answer, question.selectedOption),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionList(
      List<String> options, String answer, String? selectedOption) {
    return Column(
      children: options
          .map((option) => _buildOptionItem(option, answer, selectedOption))
          .toList(),
    );
  }

  Widget _buildOptionItem(
    String option,
    String answer,
    String? selectedOption,
  ) {
    final isAnswer = option == answer;
    // final isWronglySelected = option != answer && option == selectedOption;
    final isWronglySelected = option != answer && option == selectedOption;
    return Row(
      children: [
        Icon(
          isAnswer
              ? Icons.check_circle
              : isWronglySelected
                  ? Icons.close
                  : Icons.radio_button_off,
          color: isAnswer
              ? Colors.green
              : isWronglySelected
                  ? Colors.red
                  : Colors.grey,
        ),
        const SizedBox(width: 10.0),
        Text(option),
      ],
    );
  }
}
