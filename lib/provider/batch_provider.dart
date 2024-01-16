import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/batch.dart';

class BatchProvider extends ChangeNotifier {
  final Map<String, Batch> _batches = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Batch currentBatch = Batch.empty();

  Stream<List<BatchExam>> get expiredExamsStream =>
      _examsStream(ExamStatus.expired);
  Stream<List<BatchExam>> get ongoingExamsStream =>
      _examsStream(ExamStatus.ongoing);
  Stream<List<BatchExam>> get upcomingExamsStream =>
      _examsStream(ExamStatus.upcoming);

  Stream<List<BatchExam>> _examsStream(ExamStatus status) {
    return Stream.periodic(const Duration(seconds: 1)).map((_) =>
        currentBatch.exams.where((exam) => exam.status == status).toList());
  }

  /// Fetches batch data from Firestore using the provided [batchPath].
  ///
  /// It converts the Firestore document snapshot into a [Batch] object
  /// and stores it in the local cache. If the document does not exist,
  /// it throws an exception.
  Future<Batch> _fetchBatch(String batchPath) async {
    // TODO - restrict the access of batch fetching only to those who have access
    // TODO - add rule in firestore
    // TODO - allow fetch only if the current user id is in the batch's students array field

    try {
      final DocumentSnapshot<Batch> batchSnapshot = await _firestore
          .doc(batchPath)
          .withConverter<Batch>(
            fromFirestore: (snapshot, _) => Batch.fromFirestore(snapshot),
            toFirestore: (batch, _) => batch.toFirestore(),
          )
          .get();

      if (batchSnapshot.exists) {
        Batch batchData = batchSnapshot.data()!;

        _batches[batchPath] = batchData;

        return batchData; // Return the fetched batchData
      } else {
        if (kDebugMode) {
          print('Document does not exist for batchPath: $batchPath');
        }
        throw Exception('Document not found');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching batch: $e');
      }
      rethrow; // Rethrow the error to handle it in the UI
    }
  }

  /// Retrieves batch data from the local cache if it exists,
  /// otherwise fetches it from Firestore using the [_fetchBatch] method.
  ///
  /// If an error occurs during the fetching process, it returns an error state
  /// [Batch] object.
  Future<Batch> getBatch(String batchPath) async {
    if (_batches.containsKey(batchPath)) {
      return _batches[batchPath]!;
    } else {
      try {
        final batchData = await _fetchBatch(batchPath);
        return batchData;
      } catch (e) {
        // Handle the error if needed
        if (kDebugMode) {
          print('Error getting batch: $e');
        }
        // return BatchData.error(); // You can define an error state in BatchData
        rethrow; // Rethrow the error to handle it in the UI
      }
    }
  }

  void setBatch(String batchPath) async {
    currentBatch = await getBatch(batchPath);
    notifyListeners();
  }
}
