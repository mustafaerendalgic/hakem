import 'package:isg_ihlal/data/entity/violation.dart';

class HomeRepo {
  HomeRepo._internal();
  static final HomeRepo instance = HomeRepo._internal();
  factory HomeRepo() => instance;

  Stream<List<Violation>> get violationList async* {
    await Future.delayed(Duration(seconds: 1));
    yield <Violation>[];
  }

  Stream<List<Violation>> get archives async* {
    await Future.delayed(Duration(seconds: 1));
    yield <Violation>[];
  }

}
