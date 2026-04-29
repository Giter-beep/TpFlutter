import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class ApiService {
  final String baseUrl = "https://dummyjson.com";

  Future<List<Note>> getAllNotes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'FlutterApp',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List data = decoded['posts'];

      return data.map((e) {
        return Note(
          id: e['id'].toString(),
          titre: e['title'],
          contenu: e['body'],
          couleur: "#FFFFFF",
          dateCreation: DateTime.now(),
        );
      }).toList();
    } else {
      throw Exception("Erreur de chargement: ${response.statusCode}");
    }
  }
  Future<bool> createNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': note.titre,
        'body': note.contenu,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> deleteNote(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );

    return response.statusCode == 200;
  }
}
