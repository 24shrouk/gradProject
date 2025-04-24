import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class about extends StatelessWidget {
  const about({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: MyColors.backgroundColor,
          elevation: 0,
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
        body: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Text(
            '''
Spokify is your smart voice companion.
It helps you record, transcribe, and analyze your voice notes easily. Whether you're brainstorming, attending meetings, or capturing ideas, Spokify organizes your audio and turns it into structured, meaningful text.

🔹 Key Features:

* Real-time voice recording.

* Smart transcription using AI.

* Keyword search & content highlights.

* Ask questions about past recordings.

* Easy sharing and task creation.''',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
