import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:memorizer/views/home_view.dart';
import 'package:path_provider/path_provider.dart';

import 'models/sentence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(SentenceAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Memorizer',
      home: HomeView(),
    );
  }
}
