import 'package:farmconnect/consts/consts.dart';
import 'package:farmconnect/widgetsCommon/appLogo.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../auth_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  changeScreen() {
    Future.delayed(const Duration(seconds: 3),(){
      Get.to(() => const LoginScreen());
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(230, 46, 4, 1),
      body: Center(
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: Image.asset(icSplashBg, width: 300)),
            20.heightBox,
            appLogoWidget(),
            15 .heightBox,
            appname.text.fontFamily(bold).size(26).white.make(),
             5.heightBox,
            appversion.text.white.make(),
            //const Spacer(),
            //credits.text.white.fontFamily(semibold ).make(),
            //30.heightBox,
          ],
        ),
      ),
    );
    return const Placeholder();
  }
}
