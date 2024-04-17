
import 'package:flutter/material.dart';

import 'components.dart';
import 'constants.dart';

Widget buildLesson(controller,label)
{
  return
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: defaultformfeild(
        controller: controller,
        bordercolor: AppColors.darkBlue,
        type: TextInputType.text,
        circular: 10,
        labelTextColor: AppColors.lightOrange,
        Width: 130,
        verticalPadding: 30,
        label: label,
        validate: (value){
          if (value!.isEmpty) {
            return 'This field is required';
          }
          return null;
        },),
    );
}