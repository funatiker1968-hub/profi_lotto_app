import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lottery_drawing.dart';

class LotteryApiService {
  static const String baseUrl = 'https://api.example.com/lottery';

  final http.Client client;

  LotteryApiService({required this.client});

  Future<List<LotteryDrawing>> getLatestDrawings() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/drawings/latest'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LotteryDrawing.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load drawings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<LotteryDrawing>> getDrawingsByDate(DateTime date) async {
    try {
      final formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await client.get(Uri.parse('$baseUrl/drawings/$formattedDate'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LotteryDrawing.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load drawings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<LotteryDrawing>> searchDrawings(List<int> numbers) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/drawings/search'),
        body: json.encode({'numbers': numbers}),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => LotteryDrawing.fromJson(json)).toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> getNumberStats() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/stats/numbers'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
