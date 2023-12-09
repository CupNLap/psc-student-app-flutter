import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionType { mcq }

class Question {
  String text;
  QuestionType type;
  int timer;
  Set<String> options;
  String answer;

  Question({
    required this.text,
    required this.options,
    required this.answer,
    this.timer = 900,
    this.type = QuestionType.mcq,
  });

  factory Question.fromFirestore(DocumentSnapshot snap) {
    return Question(
      text: snap.get('text'),
      type: snap.get('type'),
      timer: snap.get('timer'),
      options: snap.get('options'),
      answer: snap.get('answer'),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['type'] = type;
    data['timer'] = timer;
    data['options'] = options;
    data['answer'] = answer;
    return data;
  }
}
