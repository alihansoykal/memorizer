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

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete?'),
              content: const Text('Do you really want to delete this item?'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  _editSentence(Sentence sentence, int index) async {
    TextEditingController textController =
        TextEditingController(text: sentence.text);
    TextEditingController meaningController =
        TextEditingController(text: sentence.meaning);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Sentence'),
          content: Column(
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
            ],
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
                if (index < widget.box.length) {
                  // Check if the index is still valid
                  final updatedSentence = Sentence(
                    text: textController.text,
                    meaning: meaningController.text,
                  );

                  // Update the item in Hive box and refresh the list
                  widget.box.putAt(index, updatedSentence);
                  setState(() {});

                  Navigator.of(context).pop();
                } else {
                  print("Index out of range error. Unable to update.");
                  Navigator.of(context).pop();
                }
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
