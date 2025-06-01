import 'package:dio/dio.dart';

class ApiService {
  // عدّلي الـ baseUrl إلى عنوان الـ FastAPI عندك
  static const String baseUrl = "http://YOUR_SERVER_IP:8000";

  final Dio _dio;

  ApiService._internal()
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  /// تبعتي النص المحول لأي إيميل باستخدام Dio
  Future<bool> sendTranscription(String toEmail) async {
    try {
      final response = await _dio.post(
        '/send_transcription/',
        data: {'to_email': toEmail},
      );
      return response.statusCode == 200;
    } on DioError catch (e) {
      print('Dio error: ${e.response?.statusCode} - ${e.response?.data}');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }
}
