// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Update the import path

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Player>> _players;

  @override
  void initState() {
    super.initState();
    _players = _apiService.getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: Icon(Icons.gamepad),
              title: Text('Lousy Rocket Game'), // Updated title
              onTap: () {
                Navigator.pushNamed(context, '/rocket'); // Updated route
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Player>>(
          future: _players,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No players found');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Player ID')),
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Score')),
                  ],
                  rows: snapshot.data!.map((player) {
                    return DataRow(cells: [
                      DataCell(Text(player.playerId.toString())),
                      DataCell(Text(player.username)),
                      DataCell(Text(player.playerScore.toString())),
                    ]);
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
