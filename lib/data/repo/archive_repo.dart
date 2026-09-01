import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';

abstract class ArchiveRepository {
  Stream<List<Violation>> get archiveList;
}

class ArchiveRepo implements ArchiveRepository {
  final FirebaseProvider firebaseProvider;
  ArchiveRepo._init(this.firebaseProvider);
  static final ArchiveRepo instance = ArchiveRepo._init(
    FirebaseProvider.instance,
  );
  factory ArchiveRepo() => instance;

  @override
  Stream<List<Violation>> get archiveList {
    return firebaseProvider.archives
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
