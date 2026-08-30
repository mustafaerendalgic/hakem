import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/states/detail_states.dart';
import 'package:isg_ihlal/util/get_user_name.dart';

class DetailRepo implements DetailActions {
  DetailRepo._();
  static final DetailRepo instance = DetailRepo._();
  factory DetailRepo() => instance;

  @override
  Future<void> cancelViolation(Violation violation) async {
    try {
      final String? uid = FirebaseProvider.instance.uid;
      if (uid == null) return;
      final docRef = await FirebaseProvider.instance.violationCollection.doc(
        violation.id,
      );
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception("İhlal bulunamadı");
      }
      final String name = await getUserName(uid);
      Violation newViolation = violation.copyWith(
        actionType: ActionType.rejected,
        actionByWho: name,
        actionWhen: DateTime.now(),
      );
      await docRef.update({});
      await FirebaseProvider.instance.archives
          .doc(violation.id)
          .set(newViolation.toMap());
    } catch (e) {
      print("Hata yakalandı: $e");
    }
  }

  @override
  Future<void> reopenViolation(Violation violation) {
    // TODO: implement reopenViolation
    throw UnimplementedError();
  }

  @override
  Future<void> resolveViolation(Violation violation) {
    // TODO: implement resolveViolation
    throw UnimplementedError();
  }

  @override
  Future<void> takeUnderReview(Violation violation) {
    // TODO: implement takeUnderReview
    throw UnimplementedError();
  }
}
