import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/core/widgets/button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 45,
                  height: 45,
                ),
                horizontalSpace(14),
                Text(
                  "Spokify",
                  style: MyFontStyle.font13RegularAcc
                      .copyWith(color: MyColors.whiteColor),
                ),
              ],
            ),
          ),
          verticalSpace(180),
          Text(
            "Let’s Get",
            style: MyFontStyle.font45Regular
                .copyWith(color: MyColors.whiteColor, height: 1.0),
          ),
          Text("Started!",
              style: MyFontStyle.font45Bold
                  .copyWith(color: MyColors.txt1Color, height: 1.0)),
          verticalSpace(90),
          RaisedGradientButton(
            width: 250,
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
              'SIGN IN',
              style: MyFontStyle.font12RegularBtn
                  .copyWith(color: MyColors.whiteColor),
            ),
          ),
          verticalSpace(30),
          Text("O R   S I N G    I N    W I T H",
              style: MyFontStyle.font13RegularBtnTxt
                  .copyWith(color: MyColors.whiteColor)),
          verticalSpace(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email,
                color: MyColors.txt1Color,
                size: 35,
              ),
              horizontalSpace(10),
              const Icon(
                Icons.facebook_outlined,
                color: MyColors.txt1Color,
                size: 35,
              )
            ],
          ),
          verticalSpace(20),
          const Divider(
            color: MyColors.whiteColor, // Line color
            thickness: 1, // Line thickness
            height: 20, // Space around the divider
          ),
          verticalSpace(20),
          Text(
            "DIDN'T HAVE ACCOUNT?",
            style: MyFontStyle.font13RegularAcc
                .copyWith(color: MyColors.whiteColor),
          ),
          Text(
            "SING UP NOW",
            style: MyFontStyle.font13RegularAcc
                .copyWith(color: MyColors.txt2Color),
          ),
        ],
      ),
    );
  }
}
