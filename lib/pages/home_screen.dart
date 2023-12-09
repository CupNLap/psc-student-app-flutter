import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:student/model/batch.dart';
import 'package:student/provider/batch_provider.dart';
import 'package:student/widgets/exam_item.dart';
import 'package:student/widgets/hero_section.dart';
import 'package:student/widgets/exam_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Get Institute Id and Batch id from local storage
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Declare Variables
  late Batch batch = Batch(name: "---");

  @override
  void initState() {
    super.initState();
    // Get Institute Id and Batch id from local storage
    _prefs.then((SharedPreferences prefs) {
      final String instituteId =
          prefs.getString('instituteId') ?? "hs7sZbNheSsejVceqcL6";
      final String batchId =
          prefs.getString('batchId') ?? "QTLwtugvxW4ja8OWg75O";

      final String batchPath = 'Institute/$instituteId/Batch/$batchId';

      // Get Batch
      Provider.of<BatchProvider>(context, listen: false)
          .getBatch(batchPath)
          .then((b) => {setState(() => batch = b)});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Group the exams to recent, upcomming and ongoing based on the start time and end time
    final List<BatchExam> expiredExams =
        batch.exams.where((exam) => exam.isExpired).toList();
    final List<BatchExam> upcommingExams =
        batch.exams.where((exam) => exam.isUpcoming).toList();
    final BatchExam ongoingExam = batch.exams
        .firstWhere((exam) => exam.isOngoing, orElse: () => BatchExam.empty());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          children: [
            Text(widget.title),
            Text(batch.name,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white)),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {/* open drawer */},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {/* open profile */},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Notice Card
            const HeroSection(),

            // Ongoing Exams
            // Single Exam Item
            const SizedBox(height: 20.0),
            Text("Ongoing Exams",
                style: Theme.of(context).textTheme.titleMedium),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ongoingExam.isEmpty
                      ? const Text("No Exams")
                      : AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ExamItem(ongoingExam),
                        ),
                ],
              ),
            ),

            // Expired Exams
            // Horizontal Scroll Section
            const SizedBox(height: 20.0),
            Text("Expired Exams",
                style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              height: MediaQuery.of(context).size.width / 2.8 * 1.6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: expiredExams.length,
                itemBuilder: (context, index) => SizedBox(
                  width: MediaQuery.of(context).size.width / 2.8,
                  child: ExamCard(expiredExams[index]),
                ),
              ),
            ),

            // Upcomming Exams
            // Vertical Scroll Section
            const SizedBox(height: 20.0),
            Text("Upcomming Exams",
                style: Theme.of(context).textTheme.titleMedium),
            ...upcommingExams.map((exam) => ExamItem(exam))
          ],
        ),
      ),
    );
  }
}
