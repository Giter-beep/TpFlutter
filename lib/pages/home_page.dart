import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import 'create_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  String _query = "";

  @override
  Widget build(BuildContext context) {


    final notes = context.watch<NoteService>().search(_query);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Notes"),


        actions: [
          Consumer<NoteService>(
            builder: (_, service, __) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("${service.count}"),
                ),
              );
            },
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              final service = context.read<NoteService>();

              if (value == "date_desc") service.sortByDateDesc();
              if (value == "date_asc") service.sortByDateAsc();
              if (value == "title_az") service.sortByTitleAZ();
              if (value == "title_za") service.sortByTitleZA();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "date_desc", child: Text("Date ↓")),
              PopupMenuItem(value: "date_asc", child: Text("Date ↑")),
              PopupMenuItem(value: "title_az", child: Text("Titre A-Z")),
              PopupMenuItem(value: "title_za", child: Text("Titre Z-A")),
            ],
          ),
        ],


        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                setState(() => _query = value);
              },
              decoration: InputDecoration(
                hintText: "Rechercher...",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: notes.isEmpty
          ? Center(
        child: Text(
          _query.isEmpty
              ? "Aucune note"
              : "Aucun résultat",
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Card(
            child: ListTile(
              leading: Container(
                width: 5,
                color: Color(int.parse(note.couleur.replaceFirst('#', '0xff'))),
              ),
              title: Text(note.titre),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.contenu.length > 30
                        ? note.contenu.substring(0, 30) + "..."
                        : note.contenu,
                  ),
                  Text(note.dateCreation.toString()),
                ],
              ),

              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(note: note),
                  ),
                );

                if (result == "deleted") {
                  context.read<NoteService>().deleteNote(note.id);
                } else if (result is Note) {
                  context.read<NoteService>().updateNote(result);
                }
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );

          if (newNote != null) {
            context.read<NoteService>().addNote(newNote);
          }
        },
      ),
    );
  }
}