import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepWidget extends StatelessWidget {
  const StepWidget({
    Key key,
    this.width,
    this.height,
    this.index,
    this.color,
    @required this.title,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget index;
  final Color color;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width ?? 32,
          height: height ?? 32,
          decoration: BoxDecoration(
            color: color ?? Get.theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(width ?? 32),
          ),
          child: Center(child: index),
        ),
        SizedBox(width: 10),
        title
      ],
    );
  }
}
