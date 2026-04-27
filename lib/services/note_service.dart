import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteService extends ChangeNotifier {
  final List<Note> _notes = [];


  List<Note> get notes => List.unmodifiable(_notes);


  int get count => _notes.length;

  void addNote(Note note) {
    _notes.insert(0, note);
    notifyListeners();
  }


  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }


  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // 🟢 البحث عن Note
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  // 🟢 البحث (bonus)
  List<Note> search(String query) {
    if (query.isEmpty) return _notes;

    return _notes.where((n) {
      return n.titre.toLowerCase().contains(query.toLowerCase()) ||
          n.contenu.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  // 🟢 ترتيب حسب التاريخ (الأحدث أولاً)
  void sortByDateDesc() {
    _notes.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
    notifyListeners();
  }

// 🟢 ترتيب حسب التاريخ (الأقدم أولاً)
  void sortByDateAsc() {
    _notes.sort((a, b) => a.dateCreation.compareTo(b.dateCreation));
    notifyListeners();
  }

// 🟢 ترتيب حسب العنوان (A → Z)
  void sortByTitleAZ() {
    _notes.sort((a, b) => a.titre.compareTo(b.titre));
    notifyListeners();
  }

// 🟢 ترتيب حسب العنوان (Z → A)
  void sortByTitleZA() {
    _notes.sort((a, b) => b.titre.compareTo(a.titre));
    notifyListeners();
  }
}