import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: SpinKitSpinningLines(
          color: HexColor('#FFFFFF'),
          duration: const Duration(milliseconds: 3000),
          size: 75.0,
        ),
      ),
    );
  }
}