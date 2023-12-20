// A class to represent an exam
import 'package:cloud_firestore/cloud_firestore.dart';

import 'question.dart';

class Exam {
  String? id;
  String code; // A unique identifier for the exam
  String name; // The name of the exam
  List<Question> questions; // A list of questions in the exam

  // A constructor for the exam class
  Exam({
    this.id,
    required this.code,
    required this.name,
    required this.questions,
  });

  /// Creates an `Exam` object from a Firestore `DocumentSnapshot`.
  ///
  /// The `snap` parameter is the Firestore `DocumentSnapshot` containing the exam data.
  /// It retrieves the exam code, name, batches, and questions from the snapshot and returns a new `Exam` object.
  factory Exam.fromFirestore(DocumentSnapshot snap) {
    final List<Question> questions =
        List.from(snap.get('questions').map((a) => Question.fromMap(a)));
    return Exam(
      id: snap.id,
      code: snap.get('code'),
      name: snap.get('name'),
      questions: questions,
    );
  }

  /// Converts the `Exam` object to a Firestore document.
  ///
  /// Returns a map containing the exam code, name, batches, and questions.
  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'name': name,
      'questions': questions,
    };
  }
}

class ExamResult {
  String userName;
  String userId;
  Timestamp startAt;
  Map<int, Response> response = {};
  List<Action> actions = [];
  Timestamp? endAt;
  double markScored = 0;
  int totalMarks = 0;

  // A constructor for the examresult class
  ExamResult({
    required this.userName,
    required this.userId,
    required this.startAt,
    required this.response,
    required this.actions,
    required this.endAt,
    required this.markScored,
    required this.totalMarks,
  });

  ExamResult.essentials({
    required this.userName,
    required this.userId,
    required this.startAt,
  });

  factory ExamResult.fromFirestore(DocumentSnapshot snap) {
    return ExamResult(
      userName: snap.get('userName'),
      userId: snap.get('userId'),
      startAt: snap.get('startAt'),
      response: snap.get('response'),
      actions: snap.get('actions'),
      endAt: snap.get('endAt'),
      markScored: snap.get('markScored'),
      totalMarks: snap.get('totalMarks'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userId': userId,
      'startAt': startAt,
      'response': {
        for (final entry in response.entries)
          entry.key.toString(): entry.value.toMap(),
      },
      'actions': actions.map((e) => e.toMap()).toList(),
      'endAt': endAt,
      'markScored': markScored,
      'totalMarks': totalMarks,
    };
  }
}

enum Actions {
  examStarted,
  examEnded,
  questionShowed, // Appeared in the screen
  questionSkipped, // Disappeared from the screen
  questionAnswered, // Disappeared from the screen
  questionTimedOut, // Disappeared from the screen
  currectOptionSelected,
  wrongOptionSelected,
  answerReviewStarted,
  answerReviewEnded,
}

Actions getActionFromString(String actionString) {
  return Actions.values.firstWhere((e) => e.name == actionString, orElse: () {
    throw ArgumentError('Invalid action string: $actionString');
  });
}

class Action {
  final int timeStamp;
  final Actions action;
  final String details;

  factory Action(
    Actions action, {
    String details = '',
  }) {
    return Action._(
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      action: action,
      details: details,
    );
  }

  Action._({
    required this.timeStamp,
    required this.action,
    this.details = '',
  });

  factory Action.fromFirestore(Map<String, dynamic> snap) {
    return Action._(
      timeStamp: snap['timeStamp'],
      action: getActionFromString(snap['action']),
      details: snap['details'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timeStamp': timeStamp,
      'action': action.name,
      'details': details,
    };
  }

  @override
  String toString() {
    return 'Action(timeStamp: $timeStamp, action: $action, details: $details)';
  }
}

/// Response Model
///
/// @param answer
/// @param timeTaken
///
/// used to record the student response for each question in an exam
class Response {
  String answer;
  int timeTaken;

  Response({
    required this.answer,
    required this.timeTaken,
  });

  factory Response.fromFirestore(Map<String, dynamic> snap) {
    return Response(
      answer: snap['answer'],
      timeTaken: snap['timeTaken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'timeTaken': timeTaken,
    };
  }
}
