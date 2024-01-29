import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/model/batch.dart';
import 'package:student/pages/exam_screen.dart';

class ExamItem extends StatelessWidget {
  const ExamItem(
    this.exam, {
    this.disabled = false,
    super.key,
  });

  final BatchExam exam;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final String formattedTime =
        DateFormat('hh:mm a MMM dd ').format(exam.startAt.toDate());

    Widget _buildContents() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    exam.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  exam.code,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedTime,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Center(child: Image.asset(exam.icon, width: 50, height: 50)),
                Text(
                  '${exam.time} minutes',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            )
          ],
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: disabled
            ? null
            : () {
                SharedPreferences.getInstance().then((pref) {
                  bool isFirstAttempt =
                      pref.getBool('${exam.ref?.path}') ?? true;

                  if (isFirstAttempt) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: Text(
                            'Are you ready to attempt the exam - "${exam.name}"?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel")),
                          TextButton(
                            onPressed: () {
                              // Close the AlertDialog
                              Navigator.pop(context);
                              // Navigate to the exam
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExamScreen(
                                    examRef: exam.ref,
                                    time: exam.time,
                                  ),
                                ),
                              );
                              pref.setBool('${exam.ref?.path}', false);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('You have already Attempted this exam')));
                  }
                });
              },
        child: _buildContents(),
      ),
    );
  }
}
