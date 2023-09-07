import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/sentence.dart';

class HomeView extends StatelessWidget {
  final sentencesBox = 'sentences';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning',
      home: FutureBuilder(
        future: Hive.openBox<Sentence>(sentencesBox),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return HomePage(box: Hive.box<Sentence>(sentencesBox));
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Box<Sentence> box;

  const HomePage({super.key, required this.box});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.box.length,
        itemBuilder: (context, index) {
          final sentence = widget.box.getAt(index);
          return ListTile(
            title: Text(sentence!.text),
            subtitle: Text(sentence.meaning),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSentence,
        child: const Icon(Icons.add),
      ),
    );
  }

  _addSentence() async {
    TextEditingController textController = TextEditingController();
    TextEditingController meaningController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Sentence'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Sentence'),
                ),
                TextField(
                  controller: meaningController,
                  decoration: const InputDecoration(labelText: 'Meaning'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                child: const Text('Add'),
                onPressed: () {
                  final sentence = Sentence(
                      text: textController.text,
                      meaning: meaningController.text);
                  widget.box.add(sentence);
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
