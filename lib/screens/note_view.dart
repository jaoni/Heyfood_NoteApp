import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/screens/note_creation.dart';
import 'package:note_app/utils/pdf_exporter.dart';

import '../models/note.dart';

class NoteView extends StatelessWidget {
  final Note note;
  final int index;
  final Function(Note) onDelete;

  const NoteView({super.key, required this.note, required this.index, required this.onDelete,});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text("Note Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteCreation(note: note, index: index),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              onDelete(note);
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await PdfExporter.exportNoteAsPdf(note);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Created: ${DateFormat('dd MMM yyyy').format(note.createdAt)}",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
            Text(
              "Last Modified: ${DateFormat('dd MMM yyyy').format(note.lastModified)}",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
            const Divider(
              height: 30,
              thickness: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.content,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await PdfExporter.exportNoteAsPdf(note);
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}