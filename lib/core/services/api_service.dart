import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gradprj/core/models/transicription.dart';
import 'package:http_parser/http_parser.dart';

class AudioService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.12:8000', // أو 10.0.2.2 للمحاكي
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
      final extension = file.path.split('.').last.toLowerCase();

      MediaType contentType;

      switch (extension) {
        case 'mp3':
          contentType = MediaType('audio', 'mpeg');
          break;
        case 'wav':
          contentType = MediaType('audio', 'wav');
          break;
        case 'ogg':
          contentType = MediaType('audio', 'ogg');
          break;
        default:
          contentType = MediaType('application', 'octet-stream');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: contentType,
        ),
      });

      final response = await _dio.post('/transcribe/', data: formData);

      print('✅ Status Code: ${response.statusCode}');
      print('✅ Response Data: ${response.data}');

      return TranscriptionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('❌ Failed to transcribe audio: $e');
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
