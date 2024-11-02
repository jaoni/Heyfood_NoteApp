import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:note_app/models/note.dart';



class NoteCreation extends StatefulWidget {
   final Note? note;
  final int? index;

  const NoteCreation({super.key, this.note, this.index});

  @override
  State<NoteCreation> createState() => _NoteCreationState();
}

class _NoteCreationState extends State<NoteCreation> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final Box<Note> noteBox = Hive.box<Note>('notes');
  Color selectedColor = Colors.red;
  List<String> selectedTags = [];
  
 final List<String> availableTags = [
    "Important",
    "Lecture Notes",
    "To-Do List",
    "Shopping List",
    "Diary",
    "Personal",
  ];
  // Define color map for tags
  final Map<String, Color> noteColors = {
    "Important": const Color(0xFFF28B82),
    "Lecture Notes": const Color(0xFFFBBC05),
    "To-Do List": const Color(0xFFA7FFEB),
    "Shopping List": const Color.fromARGB(255, 217, 8, 8),
    "Diary": const Color(0xFF9E9E9E),
    "Personal": const Color.fromARGB(255, 254, 189, 198),
  };

  // 

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      selectedColor = widget.note!.color ?? Colors.yellow;
      selectedTags = List<String>.from(widget.note!.tags);
    }
  }

  
  void saveNote() {
    final newNote = Note(
      title: titleController.text,
      content: contentController.text,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      lastModified: DateTime.now(),
      color: selectedColor,
      tags: selectedTags,
    );

    if (widget.index == null) {
      noteBox.add(newNote);
    } else {
      noteBox.putAt(widget.index!, newNote);
    }
    Navigator.pop(context);
  }

  void deleteNote() {
    if (widget.index != null) {
      noteBox.deleteAt(widget.index!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "New Note" : "Edit Note"),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: deleteNote,
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
                style: const TextStyle( fontSize: 30),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                isDense: true,
                labelText: "Title" ,
                contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                labelStyle: TextStyle(fontSize: 40),
                hintStyle: TextStyle( fontSize: 50)),
            ),
            Expanded(
              child: TextField(
                controller: contentController,
                style: const TextStyle( fontSize: 30),
                decoration: const InputDecoration(
                  isDense: true,
                    border: InputBorder.none,
                  labelText: "Content",
                  contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                labelStyle: TextStyle(fontSize: 40),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 100),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                  border: InputBorder.none,
                labelText: "Add Tag",
                 labelStyle: TextStyle(fontSize: 40),
                ),
              items: availableTags.map((tag) {
                return DropdownMenuItem(
                  value: tag,
                  child: Text(tag),
                );
              }).toList(),
              onChanged: (selected) {
                if (selected != null && !selectedTags.contains(selected)) {
                  setState(() {
                    selectedTags.add(selected);
                  });
                }
              },
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: selectedTags.map((tag) {
                return Chip(
                  label: Text(tag),
                  onDeleted: () {
                    setState(() {
                      selectedTags.remove(tag);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text("Note Color: ",style: TextStyle(fontSize: 30),
                ),
                GestureDetector(
                  onTap: () async {
                    Color? pickedColor = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Select Color"),
                          content: Wrap(
                            spacing: 8,
                            children: noteColors.entries.map((entry) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, entry.value);
                                },
                                child: CircleAvatar(
                                  backgroundColor: entry.value,
                                  radius: 20,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                    if (pickedColor != null) {
                      setState(() {
                        selectedColor = pickedColor;
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: selectedColor,
                    radius: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}