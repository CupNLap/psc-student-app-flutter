import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Define the ExamCard widget
class ExamCard extends StatelessWidget {
  final String title;
  final String code;
  final String icon;
  final Timestamp time;

  const ExamCard({
    Key? key,
    required this.title,
    required this.code,
    required this.icon,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = time.toDate();
    final String formattedTime =
        '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
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
              code,
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
                      "assets/images/icons/${icon}.gif",
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
    );
  }
}
