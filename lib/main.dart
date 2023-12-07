import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:student/model/batch.dart';
import 'package:student/widgets/exam_item.dart';
import 'package:student/widgets/hero_section.dart';
import 'package:student/widgets/exam_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alchemist Bathery',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'Alchemist'),
    );
  }
}

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
  final List<dynamic> examCards = [
    {
      'title': "Awards",
      'code': "MA01",
      'imagePath': "assets/images/icons/award.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Biology",
      'code': "PHY01",
      'imagePath': "assets/images/icons/biology.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Chemistry",
      'code': "CS01",
      'imagePath': "assets/images/icons/chemistry.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Computer",
      'code': "CHE02",
      'imagePath': "assets/images/icons/computer.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "English",
      'code': "CA",
      'imagePath': "assets/images/icons/english.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Finance",
      'code': "IT09",
      'imagePath': "assets/images/icons/finance.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Health",
      'code': "IT09",
      'imagePath': "assets/images/icons/health.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Maths",
      'code': "IT09",
      'imagePath': "assets/images/icons/math.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Physics",
      'code': "IT09",
      'imagePath': "assets/images/icons/physics.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Science",
      'code': "IT09",
      'imagePath': "assets/images/icons/science.gif",
      'date': '8:25PM 28-Nov-23'
    },
  ];

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

      // TODO - restrict the access of batch fetching only to those who have access
      // TODO - add rule in firestore
      // TODO - allow fetch only if the current user id is in the batch's students array field
      DocumentReference batchDoc = FirebaseFirestore.instance.doc(batchPath);
      batchDoc
          .withConverter<Batch>(
            fromFirestore: (snapshot, _) => Batch.fromFirestore(snapshot),
            toFirestore: (batch, _) => batch.toFirestore(),
          )
          .get()
          .then(
        (value) {
          setState(() {
            batch = value.data()!;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(
              height: 20.0,
            ),
            // Recent Exams
            // Horizontal Scroll Section
            Text("Recent Exams",
                style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              height: MediaQuery.of(context).size.width / 2.8 * 1.6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: batch.exams.length,
                itemBuilder: (context, index) => SizedBox(
                  width: MediaQuery.of(context).size.width / 2.8,
                  child: ExamCard(
                    title: batch.exams[index].name,
                    code: batch.exams[index].code,
                    icon: batch.exams[index].icon,
                    time: batch.exams[index].startAt,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20.0,
            ),
            // Upcomming Exams
            // Horizontal Scroll Section
            Text("Upcomming Exams",
                style: Theme.of(context).textTheme.titleMedium),
            ...examCards.map((exam) => ExamItem(exam))
          ],
        ),
      ),
    );
  }
}
