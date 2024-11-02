import 'package:flutter/material.dart';
import 'package:note_app/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'models/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  // Delete the box if it exists (for development/testing)
  await Hive.deleteBoxFromDisk('notes');

  // Open the notes box
  await Hive.openBox<Note>('notes');

  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

