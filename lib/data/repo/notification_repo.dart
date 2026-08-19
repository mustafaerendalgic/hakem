import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';

class NotificationRepo {
  final FirebaseProvider firebaseProvider;
  NotificationRepo._init(this.firebaseProvider);
  static final NotificationRepo instance = NotificationRepo._init(
    FirebaseProvider.instance,
  );
  factory NotificationRepo() => instance;

  Stream<List<Violation>> get getNewViolations async* {
    final String? uid = firebaseProvider.uid;
    if (uid == null) {
      yield [];
      return;
    }

    final timestampDoc = await firebaseProvider.userCollection.doc(uid).get();
    if (!timestampDoc.exists) {
      yield [];
      return;
    }

    final Map<String, dynamic>? map =
        timestampDoc.data() as Map<String, dynamic>?;
    final Timestamp? timestamp = map?['lastReadNotification'];

    if (timestamp == null) {
      yield [];
      return;
    }

    yield* firebaseProvider.violationCollection
        .where('date', isGreaterThan: timestamp)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final Map<String, dynamic> docMap =
                doc.data() as Map<String, dynamic>;
            return Violation.fromMap(doc.id, docMap);
          }).toList();
        });
  }
}
