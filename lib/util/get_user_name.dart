import 'package:isg_ihlal/data/repo/firebase_provider.dart';
import 'package:isg_ihlal/data/session/constant_strings.dart';

Future<String> getUserName(String uid) async {
  final docRef = await FirebaseProvider.instance.userCollection.doc(
    FirebaseProvider.instance.uid,
  );
  final docSnapshot = await docRef.get();
  if (!docSnapshot.exists) {
    throw Exception("Kullanıcı bulunamadı");
  }
  final Map<String, dynamic> map = docSnapshot.data() as Map<String, dynamic>;
  final String name = map[ConstantFieldStrings.name];
  return name;
}
