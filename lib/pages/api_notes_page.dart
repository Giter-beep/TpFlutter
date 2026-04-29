import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';

class ApiNotesPage extends StatefulWidget {
  @override
  _ApiNotesPageState createState() => _ApiNotesPageState();
}

class _ApiNotesPageState extends State<ApiNotesPage> {
  final ApiService api = ApiService();

  List<Note> notes = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      final data = await api.getAllNotes();

      setState(() {
        notes = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> addNote() async {
    final newNote = Note(
      id: DateTime.now().toString(),
      titre: "Nouvelle note",
      contenu: "Contenu...",
      couleur: "#FFFFFF",
      dateCreation: DateTime.now(),
    );

    final success = await api.createNote(newNote);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note ajoutée (API)")),
      );
      loadNotes();
    }
  }

  Future<void> deleteNote(String id) async {
    final success = await api.deleteNote(id);

    if (success) {
      setState(() {
        notes.removeWhere((n) => n.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Notes"),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text("Erreur: $error"))
          : notes.isEmpty
          ? Center(child: Text("Aucune note"))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Dismissible(
            key: Key(note.id),
            onDismissed: (_) => deleteNote(note.id),

            child: ListTile(
              title: Text(note.titre),
              subtitle: Text(note.contenu),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}