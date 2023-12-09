import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:student/model/question.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard(
    this.question, {
    super.key,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          QuestionView(question.text),
          const SizedBox(height: 30.0),
          OptionsView(
            question.options,
            onOptionSelected: (selectedOption) {
              print('Selected option: $selectedOption');
            },
          ),
        ]),
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
          maxLines: 4,
          style: const TextStyle(
            height: 0,
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Kodchasan',
            fontWeight: FontWeight.w600,
          ),
        ).animate().slide(begin: Offset(-1, 0)),
      ),
    );
  }
}

class OptionsView extends StatefulWidget {
  final Set<String> options;
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
      children: widget.options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 8.0,
          ),
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
