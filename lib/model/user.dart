import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String phone;
  List<DocumentReference> batches = [];

  User({
    required this.uid,
    required this.name,
    required this.phone,
    this.batches = const [],
  });

  factory User.empty() {
    return User(
      uid: '',
      name: '',
      phone: '',
    );
  }

  factory User.fromFirestore(DocumentSnapshot snap) {
    if (snap.data() == null) {
      return User.empty();
    }

    List<DocumentReference> batches =
        List<DocumentReference>.from([...snap.get('batches')]);

    return User(
      uid: snap.id,
      batches: batches,
      name: snap.get('name'),
      phone: snap.get('phone'),
    );

    
  }

  bool get isEmpty => uid.isEmpty;

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'batches': batches,
    };
  }
}
