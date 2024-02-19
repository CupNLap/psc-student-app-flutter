import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formattedDate(dynamic date) {
  if (date is DateTime) {
    return DateFormat('hh:mm a MMM dd').format(date);
  } else if (date is Timestamp) {
    return DateFormat('hh:mm a MMM dd').format(date.toDate());
  } else {
    throw ArgumentError('Invalid date type. Expected DateTime or Timestamp.');
  }
}
