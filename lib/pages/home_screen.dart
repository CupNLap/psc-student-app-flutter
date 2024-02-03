import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gobal/constants.dart';
import '../model/batch.dart';
import '../provider/batch_provider.dart';
import '../provider/user_provider.dart';
import '../widgets/exam/exam_card.dart';
import '../widgets/exam/exam_item.dart';
import '../widgets/hero_section.dart';
import '../widgets/utils/navigation/custom_bottom_navigator.dart';
import 'batch_join_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch the user details form the firestore
    Provider.of<UserProvider>(context, listen: false).fetchUserDetails().then(
      (user) {
        if (user.batches.isNotEmpty) {
          Provider.of<BatchProvider>(context, listen: false)
              .setBatch(user.batches.first.path);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var batchProvider = Provider.of<BatchProvider>(context);

    var userDetails = Provider.of<UserProvider>(context).student;
    var batch = batchProvider.currentBatch;

    // Show loading screen until the data is fetched
    if (userDetails.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show the Batch Joining page if the user has not joined any batch
    if (userDetails.batches.isEmpty) {
      return const BatchJoinPage();
    }

    // Check if the user can access the exam
    // TODO: Add the logic to check if the user can access the exam
    // TODO: Check if the user can bypass this when the network is slower, or if the user is offline
    final bool canAccessExam =
        !batch.restrictedStudentsFromExam.contains(currentUserRef);

    // Home Screen of the studnet app that shows the exam list of the batch
    return Scaffold(
      // App bar containing the batch name and sign out feature
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      // Home Screen Body contains the list of ongoing, upcomming and expired exams
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Notice Card
            const HeroSection(),

            // Notifications
            const SizedBox(height: 20.0),
            Text(
              !canAccessExam
                  ? "Oh No! Bad News! \n You can't access the exams please ask your to teacher"
                  : "No Notifications for you",
            ),

            StreamBuilder<List<BatchExam>>(
              stream: Provider.of<BatchProvider>(context, listen: false)
                  .examsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final exams = snapshot.data!;

                  final List<BatchExam> ongoingExams = exams
                      .where((exam) => exam.status == ExamStatus.ongoing)
                      .toList()
                    ..sort((a, b) => a.startAt.compareTo(b.startAt));
                  final List<BatchExam> upcomingExams = exams
                      .where((exam) => exam.status == ExamStatus.upcoming)
                      .toList()
                    ..sort((a, b) => a.startAt.compareTo(b.startAt));
                  final List<BatchExam> expiredExams = exams
                      .where((exam) => exam.status == ExamStatus.expired)
                      .toList()
                    ..sort((a, b) => b.startAt.compareTo(a.startAt));

                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ..._buildExamSection(
                          "Ongoing Exam",
                          ongoingExams,
                          (e) => AspectRatio(
                              aspectRatio: 16 / 9, child: ExamItem(e))),

                      // ..._buildExamSection("Upcoming Exam", upcomingExams,
                      //     (e) => ExamItem(e, disabled: true)),

                      if (upcomingExams.isNotEmpty) ...[
                        const SizedBox(height: 20.0),
                        Text("Upcomming Exams",
                            style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 2.8 * 1.6,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingExams.length,
                            itemBuilder: (context, index) => SizedBox(
                              width: MediaQuery.of(context).size.width / 2.8,
                              child: ExamCard(
                                upcomingExams[index],
                                disabled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ..._buildExamSection("Expired Exam", expiredExams,
                          (e) => ExamItem(e, disabled: true)),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExamSection(
      String name, List<BatchExam> exams, Widget Function(BatchExam) builder) {
    if (exams.isEmpty) {
      return <Widget>[
        const SizedBox(height: 20.0),
        Text(name, style: Theme.of(context).textTheme.headlineMedium),
        Center(child: Text("No ${name}"))
      ];
    }
    return <Widget>[
      const SizedBox(height: 20.0),
      Text(name, style: Theme.of(context).textTheme.headlineMedium),
      ...exams.map((e) => builder(e)).toList(),
    ];
  }
}
