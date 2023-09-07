import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memorizer/stores/sentence_store.dart';
import 'package:memorizer/views/sentence_view.dart';
import 'package:path_provider/path_provider.dart';

import 'models/sentence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(SentenceAdapter());
  final sentencesBox = await Hive.openBox<Sentence>('sentences');
  final sentenceStore = SentenceStore(sentencesBox);
  runApp(MyApp(sentenceStore: sentenceStore));
}

class MyApp extends StatelessWidget {
  final SentenceStore sentenceStore;

  const MyApp({super.key, required this.sentenceStore});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SentencePage(sentenceStore: sentenceStore),
    );
  }
}
