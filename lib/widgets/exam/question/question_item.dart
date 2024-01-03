import 'package:flutter/material.dart';
import 'package:student/model/question.dart';

class QuestionView extends StatefulWidget {
  const QuestionView(
    this.question, {
    this.title = "",
    this.showAnswers = false,
    this.selectedOption,
    this.onOptionSelected,
    this.selectOptionsOnlyOnce = false,
    super.key,
  })  : assert(
          onOptionSelected == null || showAnswers == false,
          'showAnswers should not be true if onOptionSelected is not null',
        ),
        assert(
          onOptionSelected != null || !selectOptionsOnlyOnce,
          'selectOptionsOnlyOnce should only be provided if onOptionSelected is provided',
        );

  final Question question;
  final String title;
  final bool showAnswers;
  final String? selectedOption;
  final Function(String option)? onOptionSelected;
  final bool selectOptionsOnlyOnce;

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  String? _currentSelectedOption;
  @override
  void initState() {
    super.initState();
    _currentSelectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          if (widget.title.isNotEmpty)
            Text(widget.title, style: const TextStyle(fontSize: 18)),
          // Question
          Text(widget.question.question),
          // Options
          for (int i = 0; i < widget.question.options.length; i++)
            GestureDetector(
              onTap: () {
                if (widget.onOptionSelected != null &&
                    (!widget.selectOptionsOnlyOnce ||
                        _currentSelectedOption == null)) {
                  setState(() {
                    _currentSelectedOption = widget.question.options[i];
                  });
                  widget.onOptionSelected!(widget.question.options[i]);
                }
              },
              child: Card(
                color: widget.question.answer == widget.question.options[i] &&
                        widget.showAnswers
                    ? Colors.green[50]
                    : _currentSelectedOption == widget.question.options[i]
                        ? Colors.blue[50] // Highlight selected option in blue
                        : Colors.white,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: double.maxFinite,
                  decoration: widget.question.answer ==
                              widget.question.options[i] &&
                          widget.showAnswers
                      ? const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.green, width: 10.0),
                          ),
                        )
                      : _currentSelectedOption == widget.question.options[i]
                          ? const BoxDecoration(
                              border: Border(
                                left:
                                    BorderSide(color: Colors.blue, width: 10.0),
                              ),
                            )
                          : null,
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.question.options[i],
                    style: TextStyle(
                      color: widget.showAnswers
                          ? widget.question.options[i] == widget.question.answer
                              ? Colors.green
                              : Colors.grey
                          : _currentSelectedOption == widget.question.options[i]
                              ? Colors.blue
                              : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
