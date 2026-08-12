import 'package:flutter/material.dart';
import 'package:isg_ihlal/theme/text_styles.dart';
import 'package:lottie/lottie.dart';

class SorryEmpty extends StatelessWidget {
  Function callback;
  String mesaj;
  SorryEmpty(this.callback, this.mesaj, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        Lottie.asset("assets/empty.json"),
        Text("Maalesef, " + mesaj + " boş görünüyor", style: TextStyles.bodyBold),
        FilledButton(
          onPressed: () {
            callback();
          },
          child: SizedBox(
            width: 100,
            child: Row(
              spacing: 4,
              children: [Icon(Icons.refresh), Text("Tekrar Dene")],
            ),
          ),
        ),
      ],
    );
  }
}
