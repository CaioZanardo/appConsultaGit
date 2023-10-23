import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _usernameController = TextEditingController();
  Map<String, dynamic> _userData = {};

  Future<void> _getUserInfo() async {
    final username = _usernameController.text;
    final response =
        await http.get(Uri.parse('https://api.github.com/users/$username'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _userData = data;
      });
    } else {
      setState(() {
        _userData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('App Consulta GitHub'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _usernameController,
                decoration:
                    InputDecoration(labelText: 'Digite o Usuário do GitHub'),
              ),
            ),
            ElevatedButton(
              onPressed: _getUserInfo,
              child: Text('Pesquisar'),
            ),
            if (_userData.isNotEmpty)
              Column(
                children: [
                  Image.network(_userData['avatar_url']),
                  Text("ID: ${_userData['id']}"),
                  Text("Repositórios: ${_userData['public_repos']}"),
                  Text("Criado em: ${_userData['created_at']}"),
                  Text("Seguidores: ${_userData['followers']}"),
                  Text("Seguindo: ${_userData['following']}"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
