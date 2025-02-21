import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/core/widgets/button.dart';
import 'package:gradprj/core/widgets/text_form_field.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/images/arrow.png",
                width: 35,
                height: 35,
              ),
            ),
            verticalSpace(80),
            Text(
              "Create an ",
              style: MyFontStyle.font45Regular
                  .copyWith(color: MyColors.whiteColor, height: 1.0),
            ),
            Text("Account!",
                style: MyFontStyle.font45Bold
                    .copyWith(color: MyColors.txt1Color, height: 1.0)),
            verticalSpace(40),
            const MyTextFormField(
              hint: "Email Address",
              isObecure: false,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: MyColors.fontColor,
              ),
            ),
            verticalSpace(20),
            const MyTextFormField(
              hint: "Username",
              isObecure: false,
              prefixIcon: Icon(
                Icons.person,
                color: MyColors.fontColor,
              ),
            ),
            verticalSpace(20),
            const MyTextFormField(
              hint: "Password",
              isObecure: false,
              prefixIcon: Icon(Icons.lock, color: MyColors.fontColor),
              suffixIcon: Icon(
                Icons.visibility,
                color: MyColors.fontColor,
              ),
            ),
            verticalSpace(20),
            const MyTextFormField(
              hint: "Confirm Password",
              isObecure: false,
              prefixIcon: Icon(Icons.lock, color: MyColors.fontColor),
              suffixIcon: Icon(
                Icons.visibility,
                color: MyColors.fontColor,
              ),
            ),
            verticalSpace(30),
            RaisedGradientButton(
              width: 350,
              gradient: const LinearGradient(
                colors: <Color>[
                  MyColors.button1Color,
                  MyColors.button2Color,
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.login);
              },
              child: Text(
                'Log In',
                style: MyFontStyle.font12RegularBtn
                    .copyWith(color: MyColors.whiteColor),
              ),
            ),
            verticalSpace(60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?   ",
                  style: MyFontStyle.font13RegularAcc.copyWith(
                    color: MyColors.fontColor,
                  ),
                ),
                Text(
                  "Sign in",
                  style: MyFontStyle.font13BoldUnderline.copyWith(
                      color: MyColors.txt2Color,
                      decoration: TextDecoration.underline,
                      decorationColor: MyColors.txt2Color),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
