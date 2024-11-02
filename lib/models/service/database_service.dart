import 'package:hive/hive.dart';
import '../note.dart';

class DatabaseService {
  final Box<Note> _noteBox;

  DatabaseService(this._noteBox); // Dependency injection for better testing

  Future<void> addNote(Note note) async {
    try {
      await _noteBox.add(note);
    } catch (e) {
      // Handle error (e.g., log it or show a message)
    }
  }

  Future<void> updateNoteAt(int index, Note note) async {
    try {
      await _noteBox.putAt(index, note);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteNoteAt(int index) async {
    try {
      await _noteBox.deleteAt(index);
    } catch (e) {
      // Handle error
    }
  }

  List<Note> getAllNotes() => _noteBox.values.toList();
}

