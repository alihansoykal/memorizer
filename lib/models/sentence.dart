import 'package:hive/hive.dart';

part 'sentence.g.dart';

enum Language { english, german, turkish }

@HiveType(typeId: 0)
class Sentence {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final String meaning;

  @HiveField(2)
  final Language? language; // Allow for a nullable Language

  Sentence({required this.text, required this.meaning, this.language});
}
