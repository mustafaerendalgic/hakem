import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';
import 'package:isg_ihlal/util/get_user_name.dart';

class DetailRepo{
  DetailRepo._();
  static final DetailRepo instance = DetailRepo._();
  factory DetailRepo() => instance;

  final String docRefConstant = "docRef";
  final String nameConstant = "name";

  Future<Map<String, dynamic>> _validationPrep(Violation violation) async {
    final String? uid = FirebaseProvider.instance.uid;
    if (uid == null) return throw Exception("Kullanıcı geçersiz");
    final docRef = await FirebaseProvider.instance.violationCollection.doc(
      violation.id,
    );
    final doc = await docRef.get();
    if (!doc.exists) {
      throw Exception("İhlal bulunamadı");
    }
    final String name = await getUserName(uid);
    return {docRefConstant: docRef, nameConstant: name};
  }

  Future<Violation?> updateViolation(
    Violation violation,
    ActionType actionType,
  ) async {
    final map = await _validationPrep(violation);
    final String name = map[nameConstant];
    final DocumentReference docRef = map[docRefConstant];
    Violation newViolation = violation.copyWith(
      actionByWho: name,
      actionWhen: DateTime.now(),
      actionType: actionType,
    );

    if (actionType == ActionType.rejected) {
      await FirebaseProvider.instance.archives
          .doc(violation.id)
          .set(newViolation.toMap());
    } else {
      // Eğer daha önce arşivdeyse arşivden silebiliriz
      final archiveDoc = await FirebaseProvider.instance.archives.doc(violation.id).get();
      if (archiveDoc.exists) {
        await FirebaseProvider.instance.archives.doc(violation.id).delete();
      }
    }

    await docRef.update(newViolation.toMap());
    return newViolation;
  }

  Future<void> markAsSeen(String violationId) async {
    final String? uid = FirebaseProvider.instance.uid;
    if (uid == null) return;
    await FirebaseProvider.instance.violationCollection
        .doc(violationId)
        .update({
      ConstantFieldStrings.seen_by: FieldValue.arrayUnion([uid]),
    });
  }
}
