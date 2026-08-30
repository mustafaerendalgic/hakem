import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:isg_ihlal/data/entity/violation.dart';
import 'package:isg_ihlal/data/entity/violation_types.dart';
import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';
import 'package:isg_ihlal/util/get_user_name.dart';

class FormRepo {
  FormRepo._();
  static final FormRepo instance = FormRepo._();
  factory FormRepo() => instance;

  Future<Violation?> convertViolation(
    XFile xFile,
    String title,
    String location,
    ViolationType violationType,
  ) async {
    if (FirebaseProvider.instance.uid == null) return null;
    Reference storage = FirebaseProvider.instance.storage.ref().child(
      xFile.name,
    );
    try {
      final String? uid = FirebaseProvider.instance.uid;
      if (uid == null) throw Exception("Kullanıcı geçersiz");
      final File file = File(xFile.path);
      final UploadTask upload = storage.putFile(file);
      final TaskSnapshot tSnapshot = await upload;
      final String downloadUrl = await tSnapshot.ref.getDownloadURL();

      final String name = await getUserName(uid);
      Violation violation = Violation(
        "0",
        downloadUrl,
        title,
        location,
        DateTime.now(),
        uid,
        violationType,
        name,
        DateTime.now(),
      );
      return violation;
    } catch (e) {
      print("Hata yakalandı: $e");
    }
  }

  Future<void> uploadViolation(Violation violation) async {
    try {
      await FirebaseProvider.instance.violationCollection.add(
        violation.toMap(),
      );
    } catch (e) {
      print("Hata yakalandı: $e");
    }
  }
}
