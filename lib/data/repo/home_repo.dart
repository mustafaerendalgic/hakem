import 'package:isg_ihlal/data/entity/violation.dart';

class HomeRepo {
  HomeRepo._internal();
  static final HomeRepo instance = HomeRepo._internal();
  factory HomeRepo() => instance;

  Stream<List<Violation>> get violationList async* {
    await Future.delayed(Duration(seconds: 1));
    yield <Violation>[Violation(0, "", "Personelin yüksek riskli bir bölgede baret takmadığı tespit edilmiştir.", "Silo Sahası, Cihaz 3", "Yüksek Riskli İhlal!", "05.08.2026", "14.53", "Yeni", 3, null,)];
  }

  Stream<List<Violation>> get archives async* {
    await Future.delayed(Duration(seconds: 1));
    yield <Violation>[];
  }

}
