import 'package:flutter/material.dart';
import '../models/note.dart';

class CreatePage extends StatefulWidget {
  final Note? note;

  CreatePage({this.note});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String _selectedColor = "#FFFFFF";

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.titre;
      _contentController.text = widget.note!.contenu;
      _selectedColor = widget.note!.couleur;
    }
  }

  void _save() {
    if (_titleController.text.isEmpty) return;

    final note = Note(
      id: widget.note?.id ?? DateTime.now().toString(),
      titre: _titleController.text,
      contenu: _contentController.text,
      couleur: _selectedColor,
      dateCreation: widget.note?.dateCreation ?? DateTime.now(),
      dateModification: DateTime.now(),
    );

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nouvelle Note")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 60,
              decoration: InputDecoration(labelText: "Titre"),
            ),
            TextField(
              controller: _contentController,
              minLines: 4,
              maxLines: 10,
              decoration: InputDecoration(labelText: "Contenu"),
            ),
            SizedBox(height: 10),

            Text("Choisir une couleur :"),

            SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: [
                "#E6194B", // أحمر قوي
                "#F58231", // برتقالي
                "#911EB4", // بنفسجي
                "#FFD700", // أصفر ذهبي
                "#46F0F0", // تركواز فاتح
                "#000000",
              ].map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColor = color);
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor:
                    Color(int.parse(color.replaceFirst('#', '0xff'))),
                    child: _selectedColor == color
                        ? Icon(Icons.check, color: Colors.black)
                        : null,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _save,
              child: Text("Sauvegarder"),
            ),
          ],
        ),
      ),
    );
  }
}