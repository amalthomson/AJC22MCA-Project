import 'package:FarmConnect/views/Home_screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:FarmConnect/content/consts.dart';
import 'package:get/get.dart';

Widget goCartButton({color, textcolor, String? varname}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: () {},
      child: varname!.text.color(textcolor).fontFamily(bold).make());
}
