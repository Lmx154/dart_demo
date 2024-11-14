import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? dotenv.env['BASE_URL']!;

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  Future<List<Player>> getPlayers() async {
    final url = Uri.parse('$baseUrl/api/Leaderboard');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((player) => Player.fromJson(player)).toList();
    } else {
      throw Exception('Failed to load players');
    }
  }
}

class Player {
  final int playerId;
  final String username;
  final int playerScore;

  Player({required this.playerId, required this.username, required this.playerScore});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playerId: json['playerId'],
      username: json['username'],
      playerScore: json['playerScore'],
    );
  }
}