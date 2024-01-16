import 'package:cloud_firestore/cloud_firestore.dart';

enum ExamStatus {
  expired,
  upcoming,
  ongoing,
  unknown,
}

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

  ExamStatus get status => isUpcoming
      ? ExamStatus.upcoming
      : isExpired
          ? ExamStatus.expired
          : isOngoing
              ? ExamStatus.ongoing
              : ExamStatus.unknown;
}

class Batch {
  String? id;
  String name; // The name of the batch
  List<DocumentReference> admins; // A list of admins of this batch
  List<DocumentReference> students; // A list of students in the batch
  List<BatchExam> exams; // A list of students in the batch
  List<DocumentReference>
      restrictedStudentsFromExam; // A list of students in the batch that is restricted from attempting exams

  // A constructor for the batch class
  Batch({
    required this.name,
    this.id,
    this.students = const [],
    this.admins = const [],
    this.exams = const [],
    this.restrictedStudentsFromExam = const [],
  });

  factory Batch.empty() {
    return Batch(
      name: '',
    );
  }

  bool get isEmpty => name.isEmpty;

  factory Batch.fromFirestore(DocumentSnapshot snap) {
    List<BatchExam> exams =
        List.from(snap.get('exams').map((a) => BatchExam.fromMap(a)));
    List<DocumentReference> adminRefs =
        List<DocumentReference>.from(snap.get('admins'));
    List<DocumentReference> studentRefs =
        List<DocumentReference>.from(snap.get('students'));
    List<DocumentReference> restrictedStudentsFromExam =
        List<DocumentReference>.from(snap.get('restrictedStudentsFromExam'));

    return Batch(
      id: snap.id,
      name: snap.get('name'),
      admins: adminRefs,
      students: studentRefs,
      exams: exams,
      restrictedStudentsFromExam: restrictedStudentsFromExam,
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
      'admins': admins.map((ref) => ref).toList(),
      'restrictedStudentsFromExam':
          restrictedStudentsFromExam.map((ref) => ref).toList(),
    };
  }
}

class BatchJoinRequest {
  DocumentReference batch;
  DocumentReference user;
  Timestamp created;
  String status;
  String userName;

  BatchJoinRequest({
    required this.userName,
    required this.batch,
    required this.user,
    required this.created,
    required this.status,
  });

  factory BatchJoinRequest.fromFirestore(DocumentSnapshot snap) {
    return BatchJoinRequest(
      userName: snap.get('userName'),
      batch: snap.get('batch'),
      user: snap.get('user'),
      created: snap.get('created'),
      status: snap.get('status'),
    );
  }

  // Used to send data to firebase-firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'batch': batch,
      'user': user,
      'created': created,
      'status': status, // pending, accepted, rejected
    };
  }
}
