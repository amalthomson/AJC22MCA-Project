import 'package:flutter/material.dart';
import 'package:FarmConnect/content/consts.dart';

Widget customTextField({String? fieldName, String? fieldNameHint, conrtoller}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldName!.text.color(Colors.black).fontFamily(semibold).size(16).make(),
        5.heightBox,
        TextFormField(
          controller: conrtoller,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontFamily: semibold,
              color: textfieldGrey,
            ),
            hintText: fieldNameHint,
            isDense: true,
            fillColor: lightGrey,
            filled: true,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.black,
            )),
          ),
        ),
        5.heightBox,
      ],
    );
}
