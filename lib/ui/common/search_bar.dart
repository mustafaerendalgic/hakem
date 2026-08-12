import 'package:flutter/material.dart';
import 'package:isg_ihlal/theme/app_colors.dart';
import 'package:isg_ihlal/theme/text_styles.dart';

class SearchBarSection extends StatelessWidget {
  SearchBarSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xffebebeb),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(Icons.search_rounded, size: 24, color: Colors.black,),
          Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  fillColor: Colors.transparent,
                  hintText: "Bir ihlal arayın...",
                  hintStyle: TextStyles.navigationLabelRegular,
                ),
              ),
            ),          
          Spacer(),
          IconButton(onPressed: () {}, icon: Icon(Icons.sort, size: 24,)),
        ],
      ),
    );
  }
}
