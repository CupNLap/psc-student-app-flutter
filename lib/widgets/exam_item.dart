import 'package:flutter/material.dart';
import 'package:student/model/batch.dart';

class ExamItem extends StatelessWidget {
  const ExamItem(
    this.exam, {
    super.key,
  });

  final BatchExam exam;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = exam.startAt.toDate();
    final String formattedTime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    exam.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  const SizedBox(height: 16.0),
                  Text(
                    '${(exam.time / 60).floor()} minutes\n${exam.time % 60} seconds',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              Image.asset('assets/images/icons/${exam.icon}.gif',
                  width: 50, height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    exam.code,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    formattedTime,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
