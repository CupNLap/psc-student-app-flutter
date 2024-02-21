import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../model/question.dart';
import '../../../provider/exam_provider.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({
    super.key,
    this.question,  // TODO - Found that this is not used
    this.questionIndex,
  }) {
    assert(question == null || questionIndex == null,
        'Exactly one of question or questionIndex must be provided, not both');
  }

  final Question? question;
  final int? questionIndex;

  @override
  Widget build(BuildContext context) {
    // Get the question object based on the available information either index or question
    Question questionObject;
    if (question != null) {
      questionObject = question!;
    } else if (questionIndex != null) {
      final examProvider = Provider.of<ExamProvider>(context, listen: false);
      questionObject = examProvider.getQuestionAtIndex(questionIndex!);
    } else {
      throw Exception('Either question or questionIndex must be provided');
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionView(questionObject.question),
            const SizedBox(height: 30.0),
            OptionsView(
              questionObject.options,
              onOptionSelected: (selectedOption) {
                Provider.of<ExamProvider>(context, listen: false)
                    .setTheSelectedOptionAtIndex(questionIndex!, selectedOption);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionView extends StatelessWidget {
  const QuestionView(
    this.question, {
    super.key,
  });

  final String question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const ShapeDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF880000), Color(0xFFF43428)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(7.79),
              bottomRight: Radius.circular(7.79),
            ),
          ),
        ),
        child: Text(
          question,
          textAlign: TextAlign.start,
          style: const TextStyle(
            height: 0,
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Kodchasan',
            fontWeight: FontWeight.w600,
          ),
        ).animate().slide(begin: const Offset(-1, 0)),
      ),
    );
  }
}

class OptionsView extends StatefulWidget {
  final List<String> options;
  final Function(String) onOptionSelected;

  const OptionsView(
    this.options, {
    required this.onOptionSelected,
    super.key,
  });

  @override
  _OptionsViewState createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedOption = option;
              });
              widget.onOptionSelected(option);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedOption == option ? Colors.red : Colors.white,
              foregroundColor:
                  selectedOption == option ? Colors.white : Colors.red,
            ),
            child: Text(
              option,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        );
      }).toList(),
    );
  }
}
