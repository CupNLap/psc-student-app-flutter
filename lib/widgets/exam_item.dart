import 'package:flutter/material.dart';

class ExamItem extends StatelessWidget {
  const ExamItem(
    this.exam, {
    super.key,
  });

  final Map exam;

  @override
  Widget build(BuildContext context) {
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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(exam['title'],
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16.0),
                  Text(
                    "50 questions\nmore questions",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              Image.asset(exam['imagePath'], width: 50, height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    exam['code'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    exam['date'],
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
