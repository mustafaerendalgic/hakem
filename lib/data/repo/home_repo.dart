import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/catalog/violation_catalog.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';

class HomeRepo {
  FirebaseProvider firebaseProvider;
  HomeRepo._internal(this.firebaseProvider);
  static final HomeRepo instance = HomeRepo._internal(
    FirebaseProvider.instance,
  );
  factory HomeRepo() => instance;

  Future<void> addViolations() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final Violation violation = Violation(
      '0',
      "https://firebasestorage.googleapis.com/v0/b/isgprojesi-dd27c.firebasestorage.app/o/mockimage.png?alt=media&token=1cdc3b45-4f4d-44ed-a4ce-eb055c47f6e6",
      "Personelin riskli bir bölgede baret takmadığı tespit edilmiştir.",
      "Silo Sahası, Cihaz 3",
      DateTime.now(),
      FirebaseProvider.instance.uid!,
      ViolationCatalog.violationType[0],
      null,
      null,
    );
    violation['date'] = FieldValue.serverTimestamp();
    await firebaseProvider.violationCollection.add(violation.toMap());
  }

  Stream<List<Violation>> get violationList {
    final String? uid = firebaseProvider.uid;
    if (uid == null) return Stream.value([]);

    return firebaseProvider.violationCollection.orderBy('date').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final map = doc.data() as Map<String, dynamic>;
          final Violation violation = Violation.fromMap(doc.id, map);
          return violation;
        }).toList();
      },
    );
  }

  Stream<List<Violation>> get archives async* {
    await Future.delayed(Duration(seconds: 1));
    yield <Violation>[];
  }
}
