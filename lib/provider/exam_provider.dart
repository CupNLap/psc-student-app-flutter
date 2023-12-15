import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/model/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/exam.dart';

class ExamProvider extends ChangeNotifier {
  final Map<String, Exam> _exams = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Exam? currentExam;
  ExamResult? currentExamResult;

  /// Fetches exam data from Firestore using the provided [examPath].
  ///
  /// It converts the Firestore document snapshot into a [Exam] object
  /// and stores it in the local cache. If the document does not exist,
  /// it throws an exception.
  Future<Exam> _fetchExam(String examPath) async {
    // TODO - restrict the access of exam fetching only to those who have access
    // TODO - add rule in firestore
    // TODO - allow fetch only if the current user id is in the exam's students array field
    try {
      final DocumentSnapshot<Exam> examSnapshot = await _firestore
          .doc(examPath)
          .withConverter<Exam>(
            fromFirestore: (snapshot, _) => Exam.fromFirestore(snapshot),
            toFirestore: (exam, _) => exam.toFirestore(),
          )
          .get();

      if (examSnapshot.exists) {
        Exam examData = examSnapshot.data()!;
        // examSnapshot.reference.path
        _exams[examPath] = examData;

        return examData; // Return the fetched examData
      } else {
        if (kDebugMode) {
          print('Document does not exist for examPath: $examPath');
        }
        throw Exception('Document not found');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching exam: $e');
      }
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Retrieves exam data from the local cache if it exists,
  /// otherwise fetches it from Firestore using the [_fetchExam] method.
  ///
  /// If an error occurs during the fetching process, it returns an error state
  /// [Exam] object.
  Future<Exam?> getExam(String examPath) async {
    if (_exams.containsKey('examPath')) {
      currentExam = _exams[examPath]!;
      return currentExam;
    } else {
      try {
        currentExam = await _fetchExam(examPath);
        return currentExam;
      } catch (e) {
        // Handle the error if needed
        if (kDebugMode) {
          print('Error getting exam: $e');
        }
        // return Exam.error(); // You can define an error state in Exam
        rethrow; // Rethrow the error to handle it in the UI
      }
    }
  }

  Question getQuestionAtIndex(int i) => currentExam!.questions[i];

  void examStarted() {
    currentExamResult = ExamResult.essentials(
      userId: auth.currentUser!.uid,
      startAt: Timestamp.now(),
    );

    // Add the exam started action
    currentExamResult!.actions.add(
      Action(
        Actions.examStarted,
        details: "{examCode:${currentExam!.code}}",
      ),
    );
  }

  void optionsSelected(int questionIndex, String selectedOption) {
    try {
      if (currentExamResult == null) {
        examStarted();
      }

      // record the current user selected option
      currentExamResult!.response[questionIndex] =
          // TODO - Add time taken
          Response(answer: selectedOption, timeTaken: 1);

      // record the state of answered question in actions list
      currentExamResult!.actions.add(
        Action(
          currentExam!.questions[questionIndex].answer == selectedOption
              ? Actions.questionAnsweredCorrectly
              : Actions.questionAnsweredWrongly,
          details: "{questionIndex:$questionIndex}",
        ),
      );

      // Update the ExamResult provider
      notifyListeners();
    } catch (e) {
      reset();
      rethrow;
    }
  }

  void examCompleted() {
    // Get the current timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // handle if the user has not started the exam yet
    if (currentExamResult == null) {
      examStarted();
    }

    // Update the exam Result intance
    currentExamResult!.actions.add(Action(
      Actions.examEnded,
      details: '{examCode:${currentExam!.code}}',
    ));
    currentExamResult!.endAt = Timestamp.fromMillisecondsSinceEpoch(timestamp);

    // Calculate and udpate the mark scored
    int markScored = 0;
    for (var element in currentExamResult!.response.entries) {
      if (element.value.answer == currentExam!.questions[element.key].answer) {
        markScored += 3;
      } else {
        markScored -= 1;
      }
    }
    currentExamResult!.markScored =
        double.parse((markScored / 3).toStringAsFixed(2));

    // Update the total marks
    currentExamResult!.totalMarks = currentExam!.questions.length;
    // Update the ExamResult provider

    _saveExamResultInFirestore();

    notifyListeners();
  }

  void reset() {
    currentExam = null;
    currentExamResult = null;
  }

  void _saveExamResultInFirestore() {
    if (currentExam != null && currentExamResult != null) {
      final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

      prefs.then((SharedPreferences prefs) {
        // TODO - replace the "demo" docs with "others" or "proderror" docs
        final String instituteId = prefs.getString('instituteId') ?? "demo";

        // save the exam result in firestore
        _firestore
            .collection('Institute')
            .doc(instituteId)
            .collection('Exams')
            .doc(currentExam?.id)
            .collection('Results')
            .add(currentExamResult!.toMap())
            .then(
          (DocumentReference<Map<String, dynamic>> value) {
            _firestore.collection("Users").doc(auth.currentUser!.uid).update({
              "ExamResults": FieldValue.arrayUnion([value])
            });
          },
        );
      });
    } else {
      throw Exception('Exam or ExamResult is null');
    }
  }

  Map<String, List<Question>> getResponseAnalysis() {
    // Initialize empty lists for categorized questions
    List<Question> correctAnswers = [];
    List<Question> wrongAnswers = [];
    List<Question> skippedQuestions = [];

    // Get the questions and responses
    List<Question> questions = currentExam!.questions;
    Map<int, Response> responses = currentExamResult!.response;

    // Loop through each question and categorize it
    for (int i = 0; i < questions.length; i++) {
      Question question = questions[i];
      Response? response = responses[i];

      // Check if the question was answered
      if (response != null) {
        // Check if the answer is correct
        question.selectedOption = response.answer;
        if (response.answer == question.answer) {
          correctAnswers.add(question);
        } else {
          wrongAnswers.add(question);
        }
      } else {
        skippedQuestions.add(question);
      }
    }

    // Use these categorized lists for further analysis
    // For example, you can calculate the following:
    // - Percentage of questions answered correctly
    // - Average time taken for each type of answer
    // - Identify areas where the user needs improvement

    print("Correctly answered questions: ${correctAnswers.length}");
    print("Wrongly answered questions: ${wrongAnswers.length}");
    print("Skipped questions: ${skippedQuestions.length}");

    return {
      "correctAnswers": correctAnswers,
      "wrongAnswers": wrongAnswers,
      "skippedQuestions": skippedQuestions
    };
  }
}
