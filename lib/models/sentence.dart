import 'package:hive/hive.dart';

part 'sentence.g.dart';

@HiveType(typeId: 0)
class Sentence {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final String meaning;

  Sentence({required this.text, required this.meaning});
}
