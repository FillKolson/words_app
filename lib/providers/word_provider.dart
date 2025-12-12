import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/word.dart';

class WordProvider extends ChangeNotifier {
  late Box<Word> _wordsBox;
  List<Word> _words = [];
  int _currentIndex = 0;

  WordProvider() {
    _wordsBox = Hive.box<Word>('words');
    _loadWords();
  }

  List<Word> get words => _words;
  Word? get currentWord => _currentIndex < _words.length ? _words[_currentIndex] : null;
  int get currentIndex => _currentIndex;
  int get totalWords => _words.length;

  void _loadWords() {
    _words = _wordsBox.values.where((w) => !w.isKnown).where((w) => w.nextReview.isBefore(DateTime.now())).toList();
    if (_words.isEmpty) {
      _initSampleWords();
    }
    notifyListeners();
  }

  void _initSampleWords() {
    List<Word> samples = [
      Word(english: 'Hello', ukrainian: 'Привіт', nextReview: DateTime.now()),
      Word(english: 'World', ukrainian: 'Світ', nextReview: DateTime.now()),
      // Додай ще 8 слів тут, наприклад:
      // Word(english: 'Apple', ukrainian: 'Яблуко', nextReview: DateTime.now()),
    ];
    for (var word in samples) {
      _wordsBox.put(word.key, word);
    }
    _loadWords();
  }

  void nextWord() {
    if (_currentIndex < _words.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    notifyListeners();
  }

  void updateCurrentWord(int difficulty) {
    currentWord?.updateDifficulty(difficulty);
    nextWord();
    notifyListeners();
  }

  int get progress => (_words.length - _words.where((w) => w.isKnown).length) / _words.length * 100;
}