import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/note_creation.dart';
import 'package:note_app/screens/note_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

final List<Color> noteColors = [
  Colors.red[100]!,
  Colors.blue[100]!,
  Colors.green[100]!,
  Colors.yellow[100]!,
  Colors.purple[100]!,
];

final _random = Random();

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final searchController = TextEditingController();
  List<Note> notes = [];
  List<Note> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    loadNotes(); // Load notes initially
    searchController.addListener(() {
      onSearchTextChanged(searchController.text);
    });
  }

  void loadNotes() {
    final box = Hive.box<Note>('notes');
    notes = box.values.toList();
    filteredNotes = notes; // Set filteredNotes to all notes initially
  }

  void onSearchTextChanged(String text) {
    setState(() {
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(text.toLowerCase()) ||
               note.content.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          
          onChanged: (text) => onSearchTextChanged(text), 
          style: const TextStyle(fontSize: 16, color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            hintText: "Search notes...",
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            fillColor: Colors.grey.shade800,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          // Update notes list whenever the Hive box changes
          notes = box.values.toList();
          filteredNotes = notes.where((note) {
            return note.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
                   note.content.toLowerCase().contains(searchController.text.toLowerCase());
          }).toList();
          if (filteredNotes.isEmpty) {
            return const Center(child: Text("No notes available",
            style: TextStyle(fontSize: 20),));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(4.0),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return Card(
                color: note.color ??
                    noteColors[_random.nextInt(noteColors.length)],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteView(
                          note: note,
                          index: index,
                          onDelete: (note) => deleteNoteFunction(note),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          note.content.length > 50
                              ? "${note.content.substring(0, 50)}..."
                              : note.content,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          DateFormat('dd MMM yyyy').format(note.lastModified),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 1),
                        if (note.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: note.tags
                                .map((tag) => Chip(
                                      label: Text(tag),
                                      backgroundColor: Colors.grey[300],
                                      labelStyle: const TextStyle(fontSize: 10),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteCreation()),
          ).then((_) {
            loadNotes(); // Refresh notes after creation
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void deleteNoteFunction(Note note) {
    note.delete();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Center(
        child: SwitchListTile(
          title: const Text("Dark Mode"),
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme(value);
          },
        ),
      ),
    );
  }
}
