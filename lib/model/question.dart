import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionType { mcq }

class Question {
  String question;
  QuestionType type;
  int timer;
  List<String> options;
  String answer;
  Set<String> topics;
  String? selectedOption;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    this.timer = 900,
    this.type = QuestionType.mcq,
    this.topics = const {},
  }) {
    if (!options.contains(answer)) {
      throw Exception(
          'There is no right answer found for this question in options');
    }
  }

  factory Question.fromFirestore(DocumentSnapshot snap) {
    return Question(
      question: snap.get('question'),
      type: snap.get('type'),
      timer: snap.get('timer'),
      options: snap.get('options'),
      topics: snap.get('topics'),
      answer: snap.get('answer'),
    );
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'],
      timer: map['timer'],
      options: [...map['options']],
      answer: map['answer'],
      topics: {...map['topics']},
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['type'] = type;
    data['timer'] = timer;
    data['options'] = options;
    data['answer'] = answer;
    data['topics'] = topics;
    return data;
  }
}
