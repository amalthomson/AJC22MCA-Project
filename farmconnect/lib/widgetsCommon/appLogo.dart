// ignore_for_file: file_names

import 'package:farmconnect/consts/consts.dart';
import 'package:flutter/cupertino.dart';

Widget appLogoWidget(){
  return Image.asset(icAppLogo).box.white.size(77, 77).padding(const EdgeInsets.all(8)).rounded.make();
}