import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/model/batch.dart';
import 'package:student/pages/quiz_screen.dart';

// Define the ExamCard widget
class ExamCard extends StatelessWidget {
  final BatchExam exam;
  final bool disabled;

  const ExamCard(
    this.exam, {
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedTime =
        DateFormat('hh:mm a MMM dd ').format(exam.startAt.toDate());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: disabled
            ? null // Clicking is disabled
            : () => {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                          'Are ready to attempt the exam - "${exam.name}"?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel")),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizScreen(quizRef: exam.ref),
                              ),
                            );
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  ),
                },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exam.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                exam.code,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(
                        exam.icon,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  formattedTime,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
