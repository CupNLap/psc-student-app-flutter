import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Collection Paths
const String pathUserCollection = "Users";
const String pathInstituteCollection = "Institute";
const String pathBatchCollection = "Batch";
const String pathExamCollection = "Exams";
const String pathBatchJoinRequestsCollection = "JoinRequests";

// Firebase
User currentUser = FirebaseAuth.instance.currentUser!;
FirebaseFirestore firestore = FirebaseFirestore.instance;

// References
DocumentReference currentUserRef =
    firestore.doc('$pathUserCollection/${currentUser.uid}');
