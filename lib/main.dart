import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:student/widgets/exam_item.dart';
import 'package:student/widgets/hero_section.dart';
import 'package:student/widgets/exam_card.dart';
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
    // CollectionReference db = FirebaseFirestore.instance.collection("places");
    CollectionReference<Map<String, dynamic>> placeCollection =
        FirebaseFirestore.instance.collection('Places');

    placeCollection.add({"first": "hai", "second": 23, "third": 3}).then(
        (value) => {print('hai')});

    return MaterialApp(
      title: 'Flutter Demo',
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
  // Declare Variables
  final List<dynamic> examCards = [
    {
      'title': "Awards",
      'code': "MA01",
      'imagePath': "assets/images/award.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Biology",
      'code': "PHY01",
      'imagePath': "assets/images/biology.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Chemistry",
      'code': "CS01",
      'imagePath': "assets/images/chemistry.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Computer",
      'code': "CHE02",
      'imagePath': "assets/images/computer.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "English",
      'code': "CA",
      'imagePath': "assets/images/english.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Finance",
      'code': "IT09",
      'imagePath': "assets/images/finance.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Health",
      'code': "IT09",
      'imagePath': "assets/images/health.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Maths",
      'code': "IT09",
      'imagePath': "assets/images/math.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Physics",
      'code': "IT09",
      'imagePath': "assets/images/physics.gif",
      'date': '8:25PM 28-Nov-23'
    },
    {
      'title': "Science",
      'code': "IT09",
      'imagePath': "assets/images/science.gif",
      'date': '8:25PM 28-Nov-23'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
          // crossAxisAlignment: CrossAxisAlignment.start,
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
              height: MediaQuery.of(context).size.width / 2.8 * 1.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: examCards.length,
                itemBuilder: (context, index) => SizedBox(
                  width: MediaQuery.of(context).size.width / 2.8,
                  child: ExamCard(
                    title: examCards[index]['title']!,
                    code: examCards[index]['code']!,
                    imagePath: examCards[index]['imagePath']!,
                    date: examCards[index]['date']!,
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
