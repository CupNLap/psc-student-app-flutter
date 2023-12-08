import 'package:cloud_firestore/cloud_firestore.dart';

class BatchExam {
  String name;
  String code;
  String icon;
  Timestamp startAt;
  Timestamp endAt;
  int time;
  DocumentReference? ref;

  // A constructor for the batchexam class
  BatchExam({
    required this.name,
    required this.code,
    required this.icon,
    required this.startAt,
    required this.endAt,
    required this.time,
    required this.ref,
  });

  factory BatchExam.empty() {
    return BatchExam(
        name: '',
        code: '',
        icon: '',
        startAt: Timestamp.now(),
        endAt: Timestamp.now(),
        time: 0,
        ref: null);
  }

  factory BatchExam.fromMap(Map<String, dynamic> map) {
    return BatchExam(
      name: map['name'],
      code: map['code'],
      icon: map['icon'],
      startAt: map['startAt'],
      endAt: map['endAt'],
      time: map['time'],
      ref: map['ref'],
    );
  }

  // Getter method to check if the exam is empty
  bool get isEmpty => ref == null;

  // Getter method to check if the exam is ongoing
  bool get isOngoing =>
      startAt.toDate().isBefore(DateTime.now()) &&
      endAt.toDate().isAfter(DateTime.now());
  
  // Getter method to check if the exam is upcoming
  bool get isUpcoming => startAt.toDate().isAfter(DateTime.now());

  // Getter method to check if the exam is expired
  bool get isExpired => endAt.toDate().isBefore(DateTime.now());
}

class Batch {
  String name; // The name of the batch
  List<DocumentReference> admins; // A list of admins of this batch
  List<DocumentReference> students; // A list of students in the batch
  List<BatchExam> exams; // A list of students in the batch

  // A constructor for the batch class
  Batch({
    required this.name,
    this.students = const [],
    this.admins = const [],
    this.exams = const [],
  });

  factory Batch.fromFirestore(DocumentSnapshot snap) {
    List<BatchExam> exams =
        List.from(snap.get('exams').map((a) => BatchExam.fromMap(a)));
    List<DocumentReference> adminRefs =
        List<DocumentReference>.from(snap.get('admins'));
    List<DocumentReference> studentRefs =
        List<DocumentReference>.from(snap.get('students'));

    return Batch(
      name: snap.get('name'),
      admins: adminRefs,
      students: studentRefs,
      exams: exams,
    );
  }

  // Used to send data to firebase-firestore
  Map<String, dynamic> toFirestore() => toMap();
  Map<String, dynamic> toJson() => toMap();
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exams': exams.map((ref) => ref).toList(),
      'students': students.map((ref) => ref).toList(),
    };
  }
}
