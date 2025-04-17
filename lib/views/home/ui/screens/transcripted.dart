import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/core/widgets/button.dart';

class FullTranscriptPage extends StatefulWidget {
  final String fullText;

  const FullTranscriptPage({super.key, required this.fullText});

  @override
  State<FullTranscriptPage> createState() => _FullTranscriptPageState();
}

class _FullTranscriptPageState extends State<FullTranscriptPage> {
  String? summary; // لحفظ النص الملخص
  bool isLoading = false; // للتحكم في حالة التحميل

  // دالة تلخيص النص
  Future<void> summarizeText() async {
    setState(() => isLoading = true); // تفعيل التحميل

    try {
      Response response = await Dio().post(
        "http://10.0.2.2:8000/summarize-text/",
        data: {"text": widget.fullText}, // إرسال النص الأصلي
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      setState(() {
        summary = response.data["summary"]; // حفظ الملخص
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Original Text :",
                  style: MyFontStyle.font38Bold
                      .copyWith(color: MyColors.whiteColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.whiteColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.fullText,
                      style: MyFontStyle.font18RegularAcc
                          .copyWith(color: MyColors.whiteColor),
                    ),
                  ),
                ),
              ),
              verticalSpace(20),

              // زر تلخيص النص
              RaisedGradientButton(
                width: 350,
                gradient: const LinearGradient(
                  colors: <Color>[
                    MyColors.button1Color,
                    MyColors.button2Color,
                  ],
                ),
                onPressed: isLoading ? null : summarizeText,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Summarize',
                        style: MyFontStyle.font18RegularAcc
                            .copyWith(color: MyColors.whiteColor),
                      ),
              ),

              verticalSpace(20),

              // عرض النص الملخص
              if (summary != null) ...[
                Text(
                  "Summary:",
                  style: MyFontStyle.font45Regular
                      .copyWith(color: MyColors.whiteColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.whiteColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        summary!,
                        style: MyFontStyle.font18RegularAcc
                            .copyWith(color: MyColors.whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
