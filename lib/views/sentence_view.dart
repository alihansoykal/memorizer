import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../models/sentence.dart';
import '../stores/sentence_store.dart';

class SentencePage extends StatefulWidget {
  final SentenceStore sentenceStore;

  const SentencePage({super.key, required this.sentenceStore});

  @override
  _SentencePageState createState() => _SentencePageState();
}

class _SentencePageState extends State<SentencePage> {
  final _textController = TextEditingController();
  final _meaningController = TextEditingController();
  Language _selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sentences"),
        actions: [
          // Dropdown menu for filtering sentences
          Observer(
            builder: (_) => DropdownButton<Language>(
              value: widget.sentenceStore.languageFilter,
              items: Language.values.map((Language language) {
                return DropdownMenuItem<Language>(
                  value: language,
                  child: Text(language.toString().split('.').last),
                );
              }).toList()
                ..add(const DropdownMenuItem<Language>(
                  value: null,
                  child: Text("All"),
                )),
              onChanged: (Language? newLanguage) {
                widget.sentenceStore.setLanguageFilter(newLanguage);
              },
            ),
          )
        ],
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          itemCount: widget.sentenceStore.filteredSentences.length,
          itemBuilder: (context, index) {
            final sentence = widget.sentenceStore.filteredSentences[index];
            return ListTile(
              title: Text(sentence.text),
              subtitle: Text(sentence.meaning),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSentenceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  _showAddSentenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Sentence"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _textController,
                decoration: const InputDecoration(hintText: "Enter sentence"),
              ),
              TextField(
                controller: _meaningController,
                decoration: const InputDecoration(hintText: "Enter meaning"),
              ),
              DropdownButton<Language>(
                value: _selectedLanguage,
                items: Language.values.map((Language language) {
                  return DropdownMenuItem<Language>(
                    value: language,
                    child: Text(language.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Language? newLanguage) {
                  setState(() {
                    if (newLanguage != null) {
                      _selectedLanguage = newLanguage;
                    } else {
                      _selectedLanguage = Language.english;
                    }
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                final newSentence = Sentence(
                  text: _textController.text,
                  meaning: _meaningController.text,
                  language: _selectedLanguage,
                );
                widget.sentenceStore.addSentence(newSentence);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
