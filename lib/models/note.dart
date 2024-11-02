import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime lastModified;

  @HiveField(4)
  List<String> tags;

  @HiveField(5)
  int? colorValue;

  Note({
    required this.title,
    required this.content,
    required this.createdAt,
    DateTime? lastModified,
    this.tags = const [],
    Color? color,
  })  : colorValue = color?.value,
        lastModified = lastModified ?? DateTime.now();

  Color? get color => colorValue != null ? Color(colorValue!) : null;
  set color(Color? newColor) => colorValue = newColor?.value;
}
