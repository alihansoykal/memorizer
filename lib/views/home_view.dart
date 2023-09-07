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
  Language _selectedLanguage = Language.english;
  DropdownButton<Language> _languageDropdown([Language? initialLanguage]) {
    return DropdownButton<Language>(
      value: initialLanguage ?? _selectedLanguage,
      items: Language.values.map((Language language) {
        return DropdownMenuItem<Language>(
          value: language,
          child: Text(language.toString().split('.').last),
        );
      }).toList(),
      onChanged: (Language? newLanguage) {
        setState(() {
          _selectedLanguage = newLanguage!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.box.length,
        itemBuilder: (context, index) {
          final sentence = widget.box.getAt(index);

          return Dismissible(
            key: Key(sentence!.text),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                widget.box.deleteAt(index);
                return true;
              } else {
                _editSentence(sentence, index);
                return false;
              }
            },
            child: ListTile(
              title: Text(sentence.text),
              subtitle: Text(sentence.meaning),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSentence,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(Icons.edit, color: Colors.white),
            Text(
              " Edit",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white),
            Text(
              " Delete",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  _editSentence(Sentence sentence, int index) async {
    TextEditingController textController =
        TextEditingController(text: sentence.text);
    TextEditingController meaningController =
        TextEditingController(text: sentence.meaning);
    Language? selectedLanguage = sentence.language;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Sentence'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Sentence'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: meaningController,
                  decoration: const InputDecoration(labelText: 'Meaning'),
                ),
                const SizedBox(height: 10),
                _languageDropdown(sentence.language)
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Update'),
              onPressed: () {
                final updatedSentence = Sentence(
                  text: textController.text,
                  meaning: meaningController.text,
                  language: selectedLanguage,
                );
                widget.box.putAt(index, updatedSentence);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _addSentence() async {
    TextEditingController textController = TextEditingController();
    TextEditingController meaningController = TextEditingController();
    Language selectedLanguage = Language.english;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Sentence'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Sentence'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: meaningController,
                  decoration: const InputDecoration(labelText: 'Meaning'),
                ),
                const SizedBox(height: 10),
                _languageDropdown(Language.english)
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final sentence = Sentence(
                  text: textController.text,
                  meaning: meaningController.text,
                  language: selectedLanguage,
                );
                widget.box.add(sentence);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
