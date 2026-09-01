import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';

class NotificationRepo {
  final FirebaseProvider firebaseProvider;
  NotificationRepo._init(this.firebaseProvider);
  static final NotificationRepo instance = NotificationRepo._init(
    FirebaseProvider.instance,
  );
  factory NotificationRepo() => instance;

  Stream<List<Violation>> get getNotifications {
    return firebaseProvider.violationCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        return Violation.fromMap(doc.id, map);
      }).toList();
    });
  }
}
