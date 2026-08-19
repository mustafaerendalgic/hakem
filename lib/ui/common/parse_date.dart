import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

DateTime parseDateTime(dynamic date) {
  if (date is Timestamp) {
    return date.toDate();
  } else if (date is String) {
    return DateTime.tryParse(date) ?? DateTime.now();
  } else {
    return DateTime.now();
  }
}

String getTheMonth(DateTime date) {
  final dateFormat = DateFormat('d MMM yyyy', 'tr_TR');
  return dateFormat.format(date);
}

String getTheTime(DateTime date) {
  final dateFormat = DateFormat('HH.mm');
  return dateFormat.format(date);
}
