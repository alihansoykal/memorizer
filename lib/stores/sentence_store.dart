// sentence_store.dart
import 'package:mobx/mobx.dart';

import '../models/sentence.dart';

part 'sentence_store.g.dart';

class SentenceStore = _SentenceStoreBase with _$SentenceStore;

abstract class _SentenceStoreBase with Store {
  final box;

  @observable
  List<Sentence> _sentences = [];

  _SentenceStoreBase(this.box) {
    _sentences = box.values.toList(); // Initialize _sentences here.
  }

  @observable
  Language? languageFilter;

  @computed
  List<Sentence> get sentences => _sentences.where((sentence) {
        if (languageFilter == null) return true;
        return sentence.language == languageFilter;
      }).toList();

  @computed
  List<Sentence> get filteredSentences {
    if (languageFilter == null) {
      return _sentences; // If no filter is set, return all sentences
    }
    // Return sentences that match the current language filter
    return _sentences
        .where((sentence) => sentence.language == languageFilter)
        .toList();
  }

  @action
  void setLanguageFilter(Language? language) {
    languageFilter = language;
  }

  @action
  void addSentence(Sentence sentence) {
    box.add(sentence); // Persist the sentence in Hive
    _sentences = box.values.toList(); // Repopulate _sentences from Hive
  }

  @action
  void updateSentence(int index, Sentence sentence) {
    box.putAt(index, sentence); // Persist the updated sentence in Hive
    _sentences = box.values.toList(); // Repopulate _sentences from Hive
  }

  @action
  void deleteSentence(int index) {
    box.deleteAt(index); // Remove the sentence from Hive
    _sentences = box.values.toList(); // Repopulate _sentences from Hive
  }
}
