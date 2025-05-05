import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gradprj/core/models/transicription.dart';

// class AudioService {
//   final Dio dio;

//   AudioService(this.dio);

//   Future<TranscriptionModel> transcribe(File file) async {
//     final formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(file.path,
//           filename: file.path.split('/').last),
//     });

//     Response response =
//         await dio.post('http://10.0.2.2:8000/transcribe', data: formData);
//     return TranscriptionModel.fromJson(response.data);
//   }
// // }
// class AudioService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'http://10.0.2.2:8000', // صح كده
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {
//         'Content-Type': 'multipart/form-data',
//       },
//     ),
//   );

//   Future<TranscriptionModel> transcribe(File file) async {
//     try {
//       final fileName = file.path.split('/').last;

//       final formData = FormData.fromMap({
//         'file': await MultipartFile.fromFile(file.path, filename: fileName),
//       });

//       final response = await _dio.post(
//         '/transcribe/', // كده هيبقى: http://10.0.2.2:8000/transcribe
//         data: formData,
//       );

//       return TranscriptionModel.fromJson(response.data);
//     } catch (e) {
//       throw Exception('Failed to transcribe audio: $e');
//     }
//   }
// }

import 'package:http_parser/http_parser.dart';

class AudioService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000', // صح كده للمحاكي Android
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    ),
  );

  Future<TranscriptionModel> transcribe(File file) async {
    try {
      final fileName = file.path.split('/').last;

      // تحديد نوع الملف بناءً على الامتداد
      final String extension = file.path.split('.').last.toLowerCase();
      MediaType contentType;

      if (extension == 'mp3') {
        contentType = MediaType('audio', 'mpeg');
      } else if (extension == 'wav') {
        contentType = MediaType('audio', 'wav');
      } else if (extension == 'ogg') {
        contentType = MediaType('audio', 'ogg');
      } else {
        // fallback في حال نوع غير معروف
        contentType = MediaType('application', 'octet-stream');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: contentType,
        ),
      });

      final response = await _dio.post(
        '/transcribe/', // http://10.0.2.2:8000/transcribe/
        data: formData,
      );

      return TranscriptionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to transcribe audio: $e');
    }
  }
}



// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:gradprj/core/models/transicription.dart';

// class AudioService {
//   final Dio dio;

//   AudioService(this.dio);

//   Future<TranscriptionModel> transcribe(File file) async {
//     final formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(
//         file.path,
//         filename: file.path.split('/').last,
//       ),
//     });

//     final response =
//         await dio.post('http://10.0.2.2:8000/transcribe', data: formData);

//     return TranscriptionModel.fromJson(response.data);
//   }
// }
