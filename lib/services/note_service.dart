import 'dart:convert'; // 🔥 جديد
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔥 جديد
import '../models/note.dart';

class NoteService extends ChangeNotifier {
  final SharedPreferences prefs; // 🔥 جديد

  final List<Note> _notes = [];

  // 🔥 constructor معدل
  NoteService(this.prefs) {
    _loadNotes(); // تحميل عند بداية التطبيق
  }

  // 🟢 Getter
  List<Note> get notes => List.unmodifiable(_notes);

  int get count => _notes.length;

  // ========================
  // 🔥 LOAD
  // ========================
  void _loadNotes() {
    final String? data = prefs.getString('notes');

    if (data != null) {
      final List decoded = jsonDecode(data);

      _notes.clear();
      _notes.addAll(decoded.map((e) => Note.fromJson(e)));
    }
  }

  // ========================
  // 🔥 SAVE
  // ========================
  void _saveNotes() {
    final List<Map<String, dynamic>> data =
    _notes.map((n) => n.toJson()).toList();

    prefs.setString('notes', jsonEncode(data));
  }

  // ========================
  // CRUD
  // ========================

  void addNote(Note note) {
    _notes.insert(0, note);
    _saveNotes(); // 🔥 جديد
    notifyListeners();
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      _saveNotes(); // 🔥 جديد
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((n) => n.id == id);
    _saveNotes(); // 🔥 جديد
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

  // 🟢 البحث
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