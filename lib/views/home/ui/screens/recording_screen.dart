// import 'dart:async';
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:flutter/material.dart';
// import 'package:gradprj/core/helpers/app_bar.dart';
// import 'package:gradprj/core/helpers/custom_raised_gradientbutton.dart';
// import 'package:gradprj/core/helpers/spacing.dart';
// import 'package:gradprj/core/theming/my_colors.dart';
// import 'package:gradprj/core/theming/my_fonts.dart';
// import 'package:gradprj/views/home/ui/widgets/note_container.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';

// class RecordingScreen extends StatefulWidget {
//   const RecordingScreen({super.key});

//   @override
//   State<RecordingScreen> createState() => _RecordingScreenState();
// }

// class _RecordingScreenState extends State<RecordingScreen>
//     with SingleTickerProviderStateMixin {
//   final record = AudioRecorder();
//   late RecorderController recorderController;
//   bool isRecording = false;
//   String filePath = '';
//   int recordingSeconds = 0;
//   Timer? _timer;

//   String enhancedText = '';
//   List<String> extractedTasks = [];
//   bool showEnhancedPage = false;
//   bool showTasks = false;

//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     recorderController = RecorderController();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     startRecording();
//   }

//   @override
//   void dispose() {
//     stopTimer();
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> startRecording() async {
//     if (await record.hasPermission()) {
//       final dir = await getApplicationDocumentsDirectory();
//       filePath = '${dir.path}/recording.m4a';

//       await recorderController.record(path: filePath);
//       setState(() => isRecording = true);
//       startTimer();
//     }
//   }

//   Future<void> stopRecording() async {
//     if (!isRecording) return;
//     await recorderController.stop();
//     stopTimer();
//     setState(() => isRecording = false);

//     // mock response
//     setState(() {
//       enhancedText =
//           "He woke up late and did not have breakfast. Then he went to work without preparing anything and forgot to send the important email to his manager. Also, he didn't talk with his team or ask for help when he needed it. At the end of the day, he felt tired but didn’t finish all his tasks.";
//       extractedTasks = [
//         "Wake up earlier",
//         "Eat breakfast",
//         "Prepare before work",
//         "Send emails on time",
//         "Communicate with team",
//         "Ask for help",
//         "Manage time better",
//       ];
//       showEnhancedPage = true;
//       _controller.forward(from: 0);
//     });
//   }

//   void startTimer() {
//     recordingSeconds = 0;
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (mounted) {
//         setState(() => recordingSeconds++);
//       }
//     });
//   }

//   void stopTimer() {
//     _timer?.cancel();
//     _timer = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showEnhancedPage) {
//       return Scaffold(
//         backgroundColor: MyColors.backgroundColor,
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppBarOfSpokify(),
//                 verticalSpace(70),
//                 const Text(' Original Text:',
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//                 verticalSpace(10),
//                 const NoteContainer(
//                   text: "Some original recorded text",
//                 ),
//                 verticalSpace(30),
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(' Enhanced Text:',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                       const SizedBox(height: 10),
//                       NoteContainer(
//                         text: enhancedText,
//                       ),
//                     ],
//                   ),
//                 ),
//                 verticalSpace(30),
//                 if (extractedTasks.isNotEmpty)
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // ElevatedButton(
//                           //   style: ElevatedButton.styleFrom(
//                           //     backgroundColor: MyColors.button2Color,
//                           //     shape: RoundedRectangleBorder(
//                           //       borderRadius: BorderRadius.circular(12),
//                           //     ),
//                           //   ),
//                           //   onPressed: () {
//                           //     setState(() {
//                           //       showTasks = !showTasks;
//                           //     });
//                           //   },
//                           //   child: Text(
//                           //     showTasks ? 'Extracted Tasks' : 'Extracted Tasks',
//                           //     style: const TextStyle(color: Colors.white),
//                           //   ),
//                           // ),
//                           CustomRaisedGradientButton(
//                               onPressed: () {
//                                 setState(() {
//                                   showTasks = !showTasks;
//                                 });
//                               },
//                               text: 'Extracted Tasks'),
//                           CustomRaisedGradientButton(
//                               onPressed: () {}, text: 'Summarization'),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           CustomRaisedGradientButton(
//                               onPressed: () {}, text: 'Add to trello'),
//                           horizontalSpace(10),
//                           CustomRaisedGradientButton(
//                               onPressed: () {}, text: 'Detect Topics'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 verticalSpace(20),
//                 if (showTasks) ...[
//                   const Text(' Extracted Tasks:',
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white)),
//                   verticalSpace(16),
//                   ...extractedTasks.map(
//                     (task) => Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: <Color>[
//                               MyColors.button1Color,
//                               MyColors.button2Color,
//                             ],
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           leading: const Icon(Icons.check_circle_outline,
//                               color: Colors.white),
//                           title: Text(
//                             task,
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ]
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     String timerText =
//         "${(recordingSeconds ~/ 60).toString().padLeft(2, '0')}:${(recordingSeconds % 60).toString().padLeft(2, '0')}";

//     return Scaffold(
//       backgroundColor: MyColors.backgroundColor,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Spokify",
//                 style: MyFontStyle.font38Bold.copyWith(color: Colors.white)),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [MyColors.button1Color, MyColors.button2Color],
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Column(
//                 children: [
//                   Text(timerText,
//                       style: const TextStyle(
//                           fontSize: 32,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 20),
//                   AudioWaveforms(
//                     enableGesture: false,
//                     size: const Size(300, 50),
//                     recorderController: recorderController,
//                     waveStyle: const WaveStyle(
//                       waveColor: Colors.white,
//                       extendWaveform: true,
//                       showMiddleLine: false,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.close, color: Colors.white),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.refresh, color: Colors.white),
//                         onPressed: () => startRecording(),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             GestureDetector(
//               onTap: () => stopRecording(),
//               child: Container(
//                 width: 70,
//                 height: 70,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [MyColors.button1Color, MyColors.button2Color],
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Center(
//                     child: Icon(Icons.stop, color: Colors.white, size: 35)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:gradprj/core/helpers/custom_raised_gradientbutton.dart';
import 'package:gradprj/core/helpers/spacing.dart';

import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';

import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  final record = AudioRecorder();
  late RecorderController recorderController;
  bool isRecording = false;
  String filePath = '';
  int recordingSeconds = 0;
  Timer? _timer;

  String enhancedText = '';
  List<String> extractedTasks = [];
  bool showEnhancedPage = false;
  bool showTasks = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    startRecording();
  }

  @override
  void dispose() {
    stopTimer();
    _controller.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      filePath = '${dir.path}/recording.m4a';

      await recorderController.record(path: filePath);
      setState(() => isRecording = true);
      startTimer();
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;
    await recorderController.stop();
    stopTimer();
    setState(() => isRecording = false);

    // mock response
    setState(() {
      enhancedText =
          "He woke up late and did not have breakfast. Then he went to work without preparing anything and forgot to send the important email to his manager. Also, he didn't talk with his team or ask for help when he needed it. At the end of the day, he felt tired but didn’t finish all his tasks.";
      extractedTasks = [
        "Wake up earlier",
        "Eat breakfast",
        "Prepare before work",
        "Send emails on time",
        "Communicate with team",
        "Ask for help",
        "Manage time better",
      ];
      showEnhancedPage = true;
      _controller.forward(from: 0);
    });
  }

  // void startTimer() {
  //   recordingSeconds = 0;
  //   timer = Timer.periodic(const Duration(seconds: 1), () {
  //     if (mounted) {
  //       setState(() => recordingSeconds++);
  //     }
  //   });
  // }

  void startTimer() {
    recordingSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => recordingSeconds++);
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    if (showEnhancedPage) {
      return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: MyColors.backgroundColor,
          leading: IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/images/arrow.png",
              width: 35,
              height: 35,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(' Original Text:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [MyColors.button1Color, MyColors.button2Color],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Some original recorded text",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(' Enhanced Text:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              MyColors.button1Color,
                              MyColors.button2Color
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          enhancedText,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (extractedTasks.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: MyColors.button2Color,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //   ),
                          //   onPressed: () {
                          //     setState(() {
                          //       showTasks = !showTasks;
                          //     });
                          //   },
                          //   child: Text(
                          //     showTasks ? 'Extracted Tasks' : 'Extracted Tasks',
                          //     style: const TextStyle(color: Colors.white),
                          //   ),
                          // ),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: MyColors.button2Color,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //   ),
                          //   onPressed: () {
                          //     // Another action here if needed
                          //   },
                          //   child: const Text(
                          //     'Summarization',
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),

                          CustomRaisedGradientButton(
                              width: 130,
                              onPressed: () {
                                setState(() {
                                  showTasks = !showTasks;
                                });
                              },
                              text: 'Extracted Tasks'),
                          CustomRaisedGradientButton(
                              width: 130,
                              onPressed: () {},
                              text: 'Summarization'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomRaisedGradientButton(
                              width: 130,
                              onPressed: () {},
                              text: 'Add to trello'),
                          CustomRaisedGradientButton(
                              width: 130,
                              onPressed: () {},
                              text: 'Detect Topics'),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                if (showTasks) ...[
                  const Text(' Extracted Tasks:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 16),
                  ...extractedTasks.map(
                    (task) => Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[
                              MyColors.button1Color,
                              MyColors.button2Color,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle_outline,
                              color: Colors.white),
                          title: Text(
                            task,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      );
    }

    String timerText =
        "${(recordingSeconds ~/ 60).toString().padLeft(2, '0')}:${(recordingSeconds % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Spokify",
                style: MyFontStyle.font38Bold.copyWith(color: Colors.white)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [MyColors.button1Color, MyColors.button2Color],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Text(timerText,
                      style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  AudioWaveforms(
                    enableGesture: false,
                    size: const Size(300, 50),
                    recorderController: recorderController,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.white,
                      extendWaveform: true,
                      showMiddleLine: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () => startRecording(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => stopRecording(),
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.button1Color, MyColors.button2Color],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child: Icon(Icons.stop, color: Colors.white, size: 35)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
