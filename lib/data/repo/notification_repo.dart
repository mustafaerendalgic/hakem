import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:rxdart/transformers.dart';

class NotificationRepo {
  final FirebaseProvider firebaseProvider;
  NotificationRepo._init(this.firebaseProvider);
  static final NotificationRepo instance = NotificationRepo._init(
    FirebaseProvider.instance,
  );
  factory NotificationRepo() => instance;

  Stream<List<Violation>> get getNewViolations {
    final uid = firebaseProvider.uid;
    if (uid == null) {
      return Stream.value([]);
    }
    return firebaseProvider.userCollection.doc(uid).snapshots().switchMap((
      userRefDoc,
    ) {
      if (!userRefDoc.exists) {
        return Stream.value([]);
      }
      final Map<String, dynamic>? map =
          userRefDoc.data() as Map<String, dynamic>?;
      final Timestamp? timestamp = map?['lastReadNotification'];
      if (timestamp == null) {
        return Stream.value([]);
      }
      return firebaseProvider.violationCollection
          .where('date', isGreaterThan: timestamp)
          .orderBy('date')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc){
              final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
              return Violation.fromMap(doc.id, map);
            }).toList();
          });
    });
  }

  Future<void> updateSeenStatus() async {
    final String? uid = firebaseProvider.uid;
    if (uid == null) return;
    await firebaseProvider.userCollection.doc(uid).update({
      'lastReadNotification': FieldValue.serverTimestamp(),
    });
  }
}
