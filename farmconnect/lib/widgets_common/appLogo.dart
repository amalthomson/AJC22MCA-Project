import 'package:flutter/material.dart';
import 'package:FarmConnect/content/consts.dart';

Widget appLogoImage() {
  return Image.asset(icAppLogo).box.white.size(120, 120).padding(EdgeInsets.all(10)).rounded.make();
}
