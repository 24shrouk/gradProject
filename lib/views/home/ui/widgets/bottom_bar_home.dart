// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gradprj/core/helpers/spacing.dart';

// import 'package:gradprj/core/routing/routing.dart';
// import 'package:gradprj/core/theming/my_colors.dart';

// import 'package:gradprj/cubit/transcription_cubit.dart';
// import 'package:gradprj/views/home/ui/screens/recording_screen.dart';

// class BottomBarHome extends StatefulWidget {
//   const BottomBarHome({super.key});

//   @override
//   State<BottomBarHome> createState() => _BottomBarHomeState();
// }

// class _BottomBarHomeState extends State<BottomBarHome> {
//   // final record = AudioRecorder();
//   // bool isRecording = false;
//   // String? transcription;
//   // String filePath = '';

//   // Future<void> startRecording() async {
//   //   try {
//   //     if (await record.hasPermission()) {
//   //       final dir = await getApplicationDocumentsDirectory();
//   //       filePath = '${dir.path}/recording.m4a';
//   //       await record.start(
//   //         const RecordConfig(encoder: AudioEncoder.aacLc),
//   //         path: filePath,
//   //       );
//   //       setState(() => isRecording = true);
//   //     }
//   //   } catch (e) {
//   //     print("❌ Error starting recording: $e");
//   //   }
//   // }

//   // Future<void> stopRecording() async {
//   //   try {
//   //     await record.stop();
//   //     setState(() => isRecording = false);
//   //     await uploadAudio(); // ✅ استدعاء رفع الملف تلقائيًا بعد التسجيل
//   //   } catch (e) {
//   //     print("❌ Error stopping recording: $e");
//   //   }
//   // }

//   // Future<void> uploadAudio() async {
//   //   if (filePath.isEmpty || !File(filePath).existsSync()) {
//   //     print("❌ No valid file to upload");
//   //     return;
//   //   }

//   //   try {
//   //     FormData formData = FormData.fromMap({
//   //       "file": await MultipartFile.fromFile(
//   //         filePath,
//   //         contentType: MediaType('audio', 'mpeg'), // ✅ النوع الصحيح
//   //       ),
//   //     });

//   //     Response response = await Dio().post(
//   //       "http://10.0.2.2:8000/transcribe-and-summarize/", // ✅ FastAPI السيرفر المحلي
//   //       data: formData,
//   //       options: Options(headers: {"Content-Type": "multipart/form-data"}),
//   //     );

//   //     setState(() {
//   //       transcription = response.data["transcription"];
//   //     });

//   //     print("✅ Transcription: $transcription");
//   //   } catch (e) {
//   //     print("❌ Error uploading file: $e");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // if (transcription != null)
//         //   Padding(
//         //     padding: const EdgeInsets.all(12.0),
//         //     child: GestureDetector(
//         //       onTap: () {
//         //         if (transcription != null && transcription!.isNotEmpty) {
//         //           Navigator.push(
//         //             context,
//         //             MaterialPageRoute(
//         //               builder: (context) => FullTranscriptPage(
//         //                 fullText: transcription!,
//         //               ),
//         //             ),
//         //           );
//         //         }
//         //       },
//         //       child: Container(
//         //         width: double.infinity,
//         //         height: 100,
//         //         decoration: BoxDecoration(
//         //           borderRadius: BorderRadius.circular(30),
//         //           gradient: const LinearGradient(
//         //             colors: <Color>[
//         //               MyColors.button1Color,
//         //               MyColors.button2Color,
//         //             ],
//         //           ),
//         //         ),
//         //         child: Padding(
//         //           padding: const EdgeInsets.only(top: 34, left: 16, right: 16),
//         //           child: Text(
//         //             transcription != null && transcription!.length > 30
//         //                 ? "${transcription!.substring(0, 30)}..." // Show first 30 characters
//         //                 : transcription ?? "No transcript available",
//         //             style: MyFontStyle.font18RegularAcc
//         //                 .copyWith(color: MyColors.whiteColor),
//         //             textAlign: TextAlign.center,
//         //           ),
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // verticalSpace(200),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               onPressed: () {
//               Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => BlocProvider.value(
//       value: context.read<TranscriptionCubit>(), // أو create لو بتبدأي جديد
//       child: const RecordingScreen(),
//     ),
//   ),
// );
//               },
//               icon: Icon(
//                 // isRecording ? Icons.stop :
//                 Icons.mic,
//                 color: MyColors.button1Color,
//                 size: 45,
//               ),
//             ),
//             horizontalSpace(20),
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.file_upload_outlined,
//                 color: MyColors.button1Color,
//                 size: 45,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradprj/core/helpers/spacing.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/cubit/transcription_cubit.dart';
import 'package:gradprj/views/home/ui/screens/recording_screen.dart';
import 'package:http_parser/http_parser.dart';

class BottomBarHome extends StatefulWidget {
  const BottomBarHome({super.key});

  @override
  State<BottomBarHome> createState() => _BottomBarHomeState();
}

class _BottomBarHomeState extends State<BottomBarHome> {
  bool _isUploading = false;
  String transcription = "";

  /// دالة لاختيار ملف صوت من الجهاز ثم إرساله إلى FastAPI
  Future<void> _pickAndUploadAudio() async {
    // 1. افتح مستعرض الملفات لاختيار ملف صوتي
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3', 'ogg', 'webm', 'opus'],
    );

    if (result == null) {
      // المستخدم ألغى الاختيار
      return;
    }

    // 2. احصل على المسار (path) للملف الذي اختاره المستخدم
    String? filePath = result.files.single.path;
    if (filePath == null) return;

    File audioFile = File(filePath);

    setState(() {
      _isUploading = true;
    });

    try {
      // 3. إعداد dio لرفع الملف عبر POST
      String url = 'http://192.168.1.12/transcribe/'; // عدلي حسب عنوان السيرفر
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        // المفتاح 'file' يجب أن يطابق اسم المعامل في الـ FastAPI endpoint
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split(Platform.pathSeparator).last,
          contentType: MediaType('audio', audioFile.path.split('.').last),
        ),
      });

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      setState(() {
        transcription = response.data["transcription"];
      });

      print("✅ Transcription: $transcription");
    } catch (e) {
      debugPrint('Error uploading file: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// 🎙 زر التسجيل
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<TranscriptionCubit>(),
                      child: const RecordingScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.mic,
                color: MyColors.button1Color,
                size: 45,
              ),
            ),

            horizontalSpace(20),

            /// ⬆ زر رفع ملف (للتطوير لاحقًا)
            // IconButton(
            //   onPressed: () {
            //     // هنا ممكن تضيفي خاصية رفع ملف لاحقًا
            //   },
            //   icon: const Icon(
            //     Icons.file_upload_outlined,
            //     color: MyColors.button1Color,
            //     size: 45,
            //   ),
            // ),

            /// ⬆ زر رفع ملف صوت
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: _isUploading ? null : _pickAndUploadAudio,
                  icon: const Icon(
                    Icons.file_upload_outlined,
                    color: MyColors.button1Color,
                    size: 45,
                  ),
                ),
                if (_isUploading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: MyColors.button1Color,
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
