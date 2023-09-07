// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SentenceStore on _SentenceStoreBase, Store {
  Computed<List<Sentence>>? _$sentencesComputed;

  @override
  List<Sentence> get sentences =>
      (_$sentencesComputed ??= Computed<List<Sentence>>(() => super.sentences,
              name: '_SentenceStoreBase.sentences'))
          .value;
  Computed<List<Sentence>>? _$filteredSentencesComputed;

  @override
  List<Sentence> get filteredSentences => (_$filteredSentencesComputed ??=
          Computed<List<Sentence>>(() => super.filteredSentences,
              name: '_SentenceStoreBase.filteredSentences'))
      .value;

  late final _$_sentencesAtom =
      Atom(name: '_SentenceStoreBase._sentences', context: context);

  @override
  List<Sentence> get _sentences {
    _$_sentencesAtom.reportRead();
    return super._sentences;
  }

  @override
  set _sentences(List<Sentence> value) {
    _$_sentencesAtom.reportWrite(value, super._sentences, () {
      super._sentences = value;
    });
  }

  late final _$languageFilterAtom =
      Atom(name: '_SentenceStoreBase.languageFilter', context: context);

  @override
  Language? get languageFilter {
    _$languageFilterAtom.reportRead();
    return super.languageFilter;
  }

  @override
  set languageFilter(Language? value) {
    _$languageFilterAtom.reportWrite(value, super.languageFilter, () {
      super.languageFilter = value;
    });
  }

  late final _$_SentenceStoreBaseActionController =
      ActionController(name: '_SentenceStoreBase', context: context);

  @override
  void setLanguageFilter(Language? language) {
    final _$actionInfo = _$_SentenceStoreBaseActionController.startAction(
        name: '_SentenceStoreBase.setLanguageFilter');
    try {
      return super.setLanguageFilter(language);
    } finally {
      _$_SentenceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSentence(Sentence sentence) {
    final _$actionInfo = _$_SentenceStoreBaseActionController.startAction(
        name: '_SentenceStoreBase.addSentence');
    try {
      return super.addSentence(sentence);
    } finally {
      _$_SentenceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSentence(int index, Sentence sentence) {
    final _$actionInfo = _$_SentenceStoreBaseActionController.startAction(
        name: '_SentenceStoreBase.updateSentence');
    try {
      return super.updateSentence(index, sentence);
    } finally {
      _$_SentenceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteSentence(int index) {
    final _$actionInfo = _$_SentenceStoreBaseActionController.startAction(
        name: '_SentenceStoreBase.deleteSentence');
    try {
      return super.deleteSentence(index);
    } finally {
      _$_SentenceStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
languageFilter: ${languageFilter},
sentences: ${sentences},
filteredSentences: ${filteredSentences}
    ''';
  }
}
