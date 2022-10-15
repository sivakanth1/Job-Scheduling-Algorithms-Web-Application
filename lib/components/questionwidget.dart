import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  final String question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: (MediaQuery.of(context).size.width) / 10,
        right: (MediaQuery.of(context).size.width) / 20,
      ),
      child: Text(
        question,
        style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700),
      ),
    );
  }
}
