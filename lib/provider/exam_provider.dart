import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/model/question.dart';

import '../model/exam.dart';

class ExamProvider extends ChangeNotifier {
  final Map<String, Exam> _exams = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  void optionsSelected(int questionIndex, String selectedOption) {
    try {
      if (currentExamResult == null) {
        currentExamResult = ExamResult(
          userId: "1", // TODO - Replace with actual user ID
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

    // Update the exam Result intance
    currentExamResult!.actions.add(Action(
      Actions.examEnded,
      details: '{examCode:${currentExam!.code}}',
    ));
    currentExamResult!.endAt = Timestamp.fromMillisecondsSinceEpoch(timestamp);

    // Calculate and udpate the mark scored
    int markScored = 0;
    currentExamResult!.response.entries.forEach((element) {
      if (element.value.answer == currentExam!.questions[element.key].answer) {
        markScored += 3;
      } else {
        markScored -= 1;
      }
    });
    currentExamResult!.markScored =
        double.parse((markScored / 3).toStringAsFixed(2));

    // Update the total marks
    currentExamResult!.totalMarks = currentExam!.questions.length;
    // Update the ExamResult provider
    notifyListeners();
  }

  void reset() {
    currentExam = null;
    currentExamResult = null;
  }
}
