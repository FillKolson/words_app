import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/word.dart';

class WordProvider extends ChangeNotifier {
  late Box<Word> box;
  List<Word> todayWords = [];

  WordProvider() {
    box = Hive.box<Word>('words');
    loadTodayWords();
  }

  void loadTodayWords() {
    todayWords = box.values
        .where((w) => !w.isKnown)
        .where((w) => w.nextReview.isBefore(DateTime.now()))
        .toList();
    notifyListeners();
  }

  Word? get currentWord => todayWords.isEmpty ? null : todayWords.first;

  void rateCurrent(int rating) {
    if (currentWord != null) {
      currentWord!.rate(rating);
      todayWords.removeAt(0);
      notifyListeners();
    }
  }

  double get progress =>
      box.isEmpty ? 0.0 : (box.values.where((w) => w.isKnown).length / box.length) * 100;

  int get totalWords => box.length;
  int get studiedToday => box.values.where((w) => w.isKnown).length;
}