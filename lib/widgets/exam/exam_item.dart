import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/batch.dart';
import '../../utils/date.dart';

class ExamItem extends StatelessWidget {
  const ExamItem(
    this.exam, {
    this.disabled = false,
    this.allowMultipleAttempt = false,
    this.onProceed,
    super.key,
  });

  final BatchExam exam;
  final bool disabled;
  final bool allowMultipleAttempt;
  final void Function()? onProceed;

  @override
  Widget build(BuildContext context) {
    Widget buildContents() {
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
                  formattedDate(exam.startAt),
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

                    bool canAttempt = allowMultipleAttempt || isFirstAttempt;

                    if (onProceed != null && canAttempt) {
                      // Previousely onProceed was used at this check only.
                      // That results in an error on runtime for some users, so we started checking at execution too
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
                                // execute the onProceed function if exist,
                                // Keep both null checking fro onProceed, as there is occurence of stability issues on production
                                if (onProceed != null) onProceed!();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('You have already Attempted this exam')));
                    }
                  });
                },
          child: buildContents()),
    );
  }
}
