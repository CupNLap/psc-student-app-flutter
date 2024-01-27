import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/gobal/constants.dart';
import 'package:student/pages/batch_join_page.dart';
import 'package:student/provider/batch_provider.dart';
import 'package:student/provider/user_provider.dart';
import 'package:student/widgets/exam/exam_card.dart';
import 'package:student/widgets/exam/exam_item.dart';
import 'package:student/widgets/hero_section.dart';

// Import widgets
import '../widgets/utils/navigation/custom_bottom_navigator.dart';

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
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserDetails()
        .then((user) {
      if (user.batches.isNotEmpty) {
        Provider.of<BatchProvider>(context, listen: false)
            .setBatch(user.batches.first.path);
        setState(() {});
      }
    });
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {/* open drawer */},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              /* open profile */
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(50.0, 100.0, 0.0, 0.0),
                items: <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'signout',
                    child: Text('Sign Out'),
                  ),
                ],
              ).then((value) {
                if (value == 'signout') {
                  // Implement sign out functionality here
                  FirebaseAuth.instance.signOut();
                }
              });
            },
          ),
        ],
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

            // Ongoing Exams
            // Single Exam Item
            const SizedBox(height: 20.0),
            Text("Ongoing Exams",
                style: Theme.of(context).textTheme.titleMedium),
            StreamBuilder(
                stream: batchProvider.ongoingExamsStream,
                builder: (context, snt) => snt.data == null || snt.data!.isEmpty
                    ? const Center(child: Text("No Exams Running Now"))
                    : Column(
                        children: [
                          ...snt.data!.map((e) => AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ExamItem(
                                  e,
                                  disabled: !canAccessExam,
                                ),
                              ))
                        ],
                      )),

            // Upcomming Exams
            // Horizontal Scroll Section
            const SizedBox(height: 20.0),
            Text("Upcomming Exams",
                style: Theme.of(context).textTheme.titleMedium),
            StreamBuilder(
              stream: batchProvider.upcomingExamsStream,
              builder: (ctx, snt) => snt.data == null || snt.data!.isEmpty
                  ? const Center(child: Text("No Upcomming Exams"))
                  : SizedBox(
                      height: MediaQuery.of(context).size.width / 2.8 * 1.6,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snt.data?.length,
                          itemBuilder: (context, index) => SizedBox(
                              width: MediaQuery.of(context).size.width / 2.8,
                              child: ExamCard(
                                snt.data![index],
                                disabled: true,
                              ))),
                    ),
            ),

            // Expired Exams
            // Vertical Scroll Section
            const SizedBox(height: 20.0),
            Text("Expired Exams",
                style: Theme.of(context).textTheme.titleMedium),
            StreamBuilder(
                stream: batchProvider.expiredExamsStream,
                builder: (ctx, snt) => snt.data == null || snt.data!.isEmpty
                    ? const Center(child: Text("No Expired Exams"))
                    : Column(
                        children: [
                          ...snt.data!.map((e) => SizedBox(
                                width: double.infinity,
                                child: ExamItem(
                                  e,
                                  disabled: true,
                                ),
                              )),
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
