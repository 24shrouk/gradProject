// import 'package:flutter/material.dart';
// import 'package:gradprj/core/helpers/app_bar.dart';
// import 'package:gradprj/core/helpers/spacing.dart';
// import 'package:gradprj/core/theming/my_colors.dart';
// import 'package:gradprj/core/theming/my_fonts.dart';
// import 'package:gradprj/views/home/ui/widgets/custom_gustor_detector.dart';
// import 'package:gradprj/views/home/ui/widgets/scrollable_bottom_sheet.dart';
// import 'package:intl/intl.dart';

// class NotePage extends StatefulWidget {
//   const NotePage({super.key});

//   @override
//   _NotePageState createState() => _NotePageState();
// }

// class _NotePageState extends State<NotePage> {
//   String title = "Spokify AI_Driven";
//   String content = "AI-Driven tool for Smarter Workflows";
//   String formattedDate = DateFormat('MMM d, y').format(DateTime.now());
//   void _editText(String field) {
//     TextEditingController controller = TextEditingController(
//       text: field == 'title' ? title : content,
//     );

//     showDialogEdite(field, controller);
//   }

//   Future<dynamic> showDialogEdite(
//       String field, TextEditingController controller) {
//     return showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: MyColors.backgroundColor,
//         title: Text(
//           "Edit ${field == 'title' ? 'Title' : 'Content'}",
//           style: TextStyle(color: Colors.white),
//         ),
//         content: TextField(
//           controller: controller,
//           maxLines: field == 'title' ? 2 : 5,
//           style: TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: field == 'title' ? 'Enter title' : 'Enter content',
//             hintStyle: TextStyle(color: Colors.white54),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 if (field == 'title') {
//                   title = controller.text;
//                 } else {
//                   content = controller.text;
//                 }
//               });
//               Navigator.pop(context);
//             },
//             child: Text(
//               "Save",
//               style: TextStyle(color: MyColors.button1Color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _editBoth() {
//     TextEditingController titleController = TextEditingController(text: title);
//     TextEditingController contentController = TextEditingController(
//       text: content,
//     );

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: MyColors.backgroundColor,
//         title: Text("Edit Note", style: TextStyle(color: Colors.white)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               maxLines: 2,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Enter title',
//                 hintStyle: TextStyle(color: Colors.white54),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: contentController,
//               maxLines: 5,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Enter content',
//                 hintStyle: TextStyle(color: Colors.white54),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 title = titleController.text;
//                 content = contentController.text;
//               });
//               Navigator.pop(context);
//             },
//             child: Text(
//               "Save",
//               style: TextStyle(color: MyColors.button1Color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSnack(String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.backgroundColor,
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppBarOfSpokify(
//                   icon: const Icon(Icons.edit, color: Colors.white),
//                   onPressed: _editBoth,
//                 ),
//                 Center(
//                   child: Text(
//                     formattedDate,
//                     style: MyFontStyle.font12RegularBtn
//                         .copyWith(color: MyColors.whiteColor),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 CustomGestureDetector(
//                   title: title,
//                   onTap: () {
//                     _editText('title');
//                   },
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   height: 4,
//                   width: 40,
//                   color: MyColors.button2Color,
//                 ),
//                 verticalSpace(10),
//                 CustomGestureDetector(
//                     title: content,
//                     onTap: () {
//                       _editText('content');
//                     })
//               ],
//             ),
//           ),
//           CustomDraggableScrollableSheet(
//             transcriptionText: content,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/app_bar.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:gradprj/views/home/ui/widgets/custom_gustor_detector.dart';
import 'package:gradprj/views/home/ui/widgets/scrollable_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class NotePage extends StatefulWidget {
  String content;

  NotePage({
    super.key,
    required this.content,
  });

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title = "Spokify AI_Driven";

  String formattedDate = DateFormat('MMM d, y').format(DateTime.now());
  bool _isLoadingTranscript = false;

  @override
  void _editText(String field) {
    TextEditingController controller = TextEditingController(
      text: field == 'title' ? title : widget.content,
    );

    showDialogEdite(field, controller);
  }

  Future<dynamic> showDialogEdite(
      String field, TextEditingController controller) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MyColors.backgroundColor,
        title: Text(
          "Edit ${field == 'title' ? 'Title' : 'Content'}",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          maxLines: field == 'title' ? 2 : 5,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: field == 'title' ? 'Enter title' : 'Enter content',
            hintStyle: const TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (field == 'title') {
                  title = controller.text;
                } else {
                  widget.content = controller.text;
                }
              });
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: MyColors.button1Color),
            ),
          ),
        ],
      ),
    );
  }

  void _editBoth() {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController contentController =
        TextEditingController(text: widget.content);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MyColors.backgroundColor,
        title: const Text("Edit Note", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter title',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter content',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                title = titleController.text;
                widget.content = contentController.text;
              });
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: MyColors.button1Color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarOfSpokify(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: _editBoth,
                  ),
                  Center(
                    child: Text(
                      formattedDate,
                      style: MyFontStyle.font12RegularBtn
                          .copyWith(color: MyColors.whiteColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomGestureDetector(
                    title: title,
                    onTap: () => _editText('title'),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 4,
                    width: 40,
                    color: MyColors.button2Color,
                  ),
                  verticalSpace(10),
                  _isLoadingTranscript
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: MyColors.button1Color,
                          ),
                        )
                      : CustomGestureDetector(
                          title: widget.content,
                          onTap: () => _editText('content'),
                        ),
                ],
              ),
            ),
          ),
          CustomDraggableScrollableSheet(
            transcriptionText: widget.content,
          ),
        ],
      ),
    );
  }
}
