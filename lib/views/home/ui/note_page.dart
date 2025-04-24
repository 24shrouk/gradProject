// import 'package:flutter/material.dart';
// import 'package:gradprj/core/theming/my_colors.dart';

// class MyNoteApp extends StatelessWidget {
//   const MyNoteApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: NotePage(), debugShowCheckedModeBanner: false);
//   }
// }

// class NotePage extends StatefulWidget {
//   const NotePage({super.key});

//   @override
//   _NotePageState createState() => _NotePageState();
// }

// class _NotePageState extends State<NotePage> {
//   String title = "Introduction from\nShino";
//   String content = "Hello, my name is Shino. How are you?";
//   String date = "Apr 12, 2025";

//   void _editText(String field) {
//     TextEditingController controller = TextEditingController(
//       text: field == 'title' ? title : content,
//     );

//     showDialog(
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
//       appBar: AppBar(
//         backgroundColor: MyColors.backgroundColor,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit, color: Colors.white),
//             onPressed: _editBoth,
//           ),
//         ],
//         leading: IconButton(
//           onPressed: () {},
//           icon: Image.asset(
//             "assets/images/arrow.png",
//             width: 35,
//             height: 35,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     date,
//                     style: TextStyle(color: Colors.white70, fontSize: 16),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () => _editText('title'),
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   height: 4,
//                   width: 40,
//                   color: MyColors.button2Color,
//                 ),
//                 SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: () => _editText('content'),
//                   child: Text(
//                     content,
//                     style: TextStyle(color: Colors.white70, fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           DraggableScrollableSheet(
//             initialChildSize: 0.13,
//             minChildSize: 0.08,
//             maxChildSize: 0.5,
//             builder: (_, controller) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: MyColors.backgroundColor,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//                 ),
//                 child: ListView(
//                   controller: controller,
//                   padding: EdgeInsets.all(20),
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.white30,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Icon(Icons.share, color: Colors.white),
//                         Icon(Icons.image, color: Colors.white),
//                         Icon(Icons.copy, color: Colors.white),
//                         Icon(Icons.delete, color: Colors.white),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     Center(
//                       child: Text(
//                         "+ add tags",
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         OutlinedButton(
//                           onPressed: () {},
//                           child: Text("view transcript"),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                         OutlinedButton.icon(
//                           onPressed: () {},
//                           icon: Icon(Icons.mic, color: Colors.white),
//                           label: Text("append to note"),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:intl/intl.dart';

class MyNoteApp extends StatelessWidget {
  const MyNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NotePage(), debugShowCheckedModeBanner: false);
  }
}

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title = "Spokify AI_Driven";
  String content = "AI-Driven tool for Smarter Workflows";
  String formattedDate = DateFormat('MMM d, y').format(DateTime.now());
  void _editText(String field) {
    TextEditingController controller = TextEditingController(
      text: field == 'title' ? title : content,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MyColors.backgroundColor,
        title: Text(
          "Edit ${field == 'title' ? 'Title' : 'Content'}",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          maxLines: field == 'title' ? 2 : 5,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: field == 'title' ? 'Enter title' : 'Enter content',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (field == 'title') {
                  title = controller.text;
                } else {
                  content = controller.text;
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
    TextEditingController contentController = TextEditingController(
      text: content,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MyColors.backgroundColor,
        title: Text("Edit Note", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              maxLines: 2,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter title',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
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
                content = contentController.text;
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

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _editBoth,
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/images/arrow.png",
            width: 35,
            height: 35,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _editText('title'),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  height: 4,
                  width: 40,
                  color: MyColors.button2Color,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _editText('content'),
                  child: Text(
                    content,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.13,
            minChildSize: 0.08,
            maxChildSize: 0.5,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: MyColors.backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: ListView(
                  controller: controller,
                  padding: EdgeInsets.all(12),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.share, color: Colors.white),
                        Icon(Icons.image, color: Colors.white),
                        Icon(Icons.copy, color: Colors.white),
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        "+ add tags",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Text("view transcript"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.mic, color: Colors.white),
                          label: Text("append to note"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          child: Text("Summarizing"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.search, color: Colors.white),
                          label: Text("detected topics"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
