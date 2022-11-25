/*
 * File name: horizontal_stepper_widget.dart
 * Last modified: 2022.10.16 at 12:23:12
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/step_widget.dart';

class HorizontalStepperWidget extends StatelessWidget {
  const HorizontalStepperWidget({
    Key key,
    this.steps,
    this.padding,
    this.controller,
  }) : super(key: key);

  final List<StepWidget> steps;
  final EdgeInsets padding;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: BouncingScrollPhysics(),
        controller: controller,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: List.generate(steps.length, (index) {
          if (index < steps.length - 1)
            return Row(children: [
              steps.elementAt(index),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  width: 20,
                  child: Divider(
                    thickness: 3,
                    color: Get.theme.focusColor.withOpacity(0.4),
                  ),
                ),
              ),
            ]);
          else
            return steps.elementAt(index);
        }),
      ),
    );
  }
}
