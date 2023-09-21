import 'package:FarmConnect/views/Home_screens/Home.dart';
import 'package:FarmConnect/views/auth_screens/login_page.dart';
import 'package:FarmConnect/widgets_common/appLogo.dart';
import 'package:FarmConnect/widgets_common/bg_widget.dart';
import 'package:FarmConnect/widgets_common/customtextfields.dart';
import 'package:FarmConnect/widgets_common/redbutton.dart';
import 'package:flutter/material.dart';
import 'package:FarmConnect/content/consts.dart';
import 'package:get/get.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordReController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            appLogoImage(),
            10.heightBox,
            "Welcome to $appname !!"
                .text
                .fontFamily(bold)
                .size(18)
                .white
                .make(),
            15.heightBox,
            Column(
              children: [
                customTextField(fieldName: name, controller: nameController),
                customTextField(fieldName: email, controller: emailController),
                customTextField(fieldName: password, controller: passwordController),
                customTextField(fieldName: retypePass, controller: passwordReController),
                5.heightBox,
                Row(
                  children: [
                    Checkbox(
                        value: isCheck,
                        activeColor: redColor,
                        checkColor: whiteColor,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        }),
                    Expanded(
                      child: RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "I agrees to the",
                            style: TextStyle(
                              color: fontGrey,
                              fontFamily: regular,
                            )),
                        TextSpan(
                            text: terms,
                            style: TextStyle(
                              color: redColor,
                              fontFamily: bold,
                            )),
                        TextSpan(
                            text: "& ",
                            style: TextStyle(
                              color: fontGrey,
                              fontFamily: regular,
                            )),
                        TextSpan(
                            text: privacyTerms,
                            style: TextStyle(
                              color: redColor,
                              fontFamily: bold,
                            ))
                      ])),
                    )
                  ],
                ),
                5.heightBox,
                redButton(
                  // onPress: () {
                  //   Get.to(() => homeScreen());
                  // },
                  color: isCheck == true ? redColor : lightGrey,
                  textcolor: whiteColor,
                  varname: signup,
                ).box.width(context.screenWidth - 50).make(),
                20.heightBox,
                RichText(
                    text: const TextSpan(
                  children: [
                    TextSpan(
                        text: alreadyAccount,
                        style: TextStyle(
                          fontFamily: bold,
                          color: fontGrey,
                        )),
                    TextSpan(
                        text: login,
                        style: TextStyle(
                          fontFamily: bold,
                          color: redColor,
                        )),
                  ],
                )).onTap(() {
                  Get.to(() => loginPage());
                })
              ],
            )
                .box
                .white
                .padding(EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .rounded
                .shadowMd
                .make(),
          ],
        ),
      ),
    ));
  }
}
