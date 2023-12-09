// A class to represent an exam
import 'package:cloud_firestore/cloud_firestore.dart';

import 'question.dart';

class Exam {
  String code; // A unique identifier for the exam
  String name; // The name of the exam
  List batches; // The batch that the exam is for
  List<Question> questions; // A list of questions in the exam
  // TODO - uncomment and create a list of results
  // List<Result> results; // A list of results for the exam
  // NOFIELDS - starting and ending time is not in Exam but in BatchExam

  // A constructor for the exam class
  Exam({
    required this.code,
    required this.name,
    required this.batches,
    required this.questions,
    // required this.results,
  });

  factory Exam.fromFirestore(DocumentSnapshot snap) {
    final List<Question> questions =
        List.from(snap.get('questions').map((a) => Question.fromMap(a)));
    return Exam(
      code: snap.get('code'),
      name: snap.get('name'),
      batches: snap.get('batches'),
      questions: questions,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'name': name,
      'batchs': batches,
      'questions': questions,
    };
  }
}
