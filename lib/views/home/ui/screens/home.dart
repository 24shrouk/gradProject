import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/views/home/ui/widgets/app_bar_home.dart';
import 'package:gradprj/views/home/ui/widgets/bottom_bar_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 41),
              child: AppBarHome(),
            ),
            verticalSpace(100),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: <Color>[
                      MyColors.button1Color,
                      MyColors.button2Color,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 34, left: 16, right: 16),
                  child: Text(
                    "AI-Driven tool for Smarter Workflows",
                    style: MyFontStyle.font18RegularAcc
                        .copyWith(color: MyColors.whiteColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            verticalSpace(50),
            const BottomBarHome(),
          ],
        ),
      ),
    );
  }
}
