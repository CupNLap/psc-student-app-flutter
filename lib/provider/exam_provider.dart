import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/exam.dart';

class ExamProvider extends ChangeNotifier {
  final Map<String, Exam> _exams = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  Future<Exam> getExam(String examPath) async {
    if (_exams.containsKey('examPath')) {
      return _exams[examPath]!;
    } else {
      try {
        Exam examData = await _fetchExam(examPath);
        return examData;
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
}
