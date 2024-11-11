import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<void> submitScore(String playerName, int score) async {
    final url = Uri.parse('$baseUrl/submit_score');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': playerName, 'score': score}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit score');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final url = Uri.parse('$baseUrl/leaderboard');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch leaderboard');
    }
  }
}
