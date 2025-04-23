import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gradprj/core/theming/my_colors.dart';
import 'package:gradprj/core/theming/my_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  final record = AudioRecorder();
  late RecorderController recorderController;
  bool isRecording = false;
  String filePath = '';
  int recordingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
    startRecording();
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
    await uploadAudio();
  }

  void startTimer() {
    recordingSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => recordingSeconds++);
      }
    });
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = null;
  }

  Future<void> uploadAudio() async {
    if (filePath.isEmpty || !File(filePath).existsSync()) return;

    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          contentType: MediaType('audio', 'mpeg'),
        ),
      });

      await Dio().post(
        "http://10.0.2.2:8000/transcribe-and-summarize/",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
    } catch (e) {
      print("❌ Upload error: $e");
    }
  }

  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  colors: <Color>[
                    MyColors.button1Color,
                    MyColors.button2Color,
                  ],
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
              onTap: () => stopRecording().then((_) => Navigator.pop(context)),
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[
                        MyColors.button1Color,
                        MyColors.button2Color,
                      ],
                    ),
                    shape: BoxShape.circle),
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
