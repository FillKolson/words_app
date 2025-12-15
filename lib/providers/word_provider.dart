import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_type.dart';
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

  double get progress => box.isEmpty
      ? 0.0
      : (box.values.where((w) => w.isKnown).length / box.length) * 100;

  int get totalWords => box.length;
  int get studiedToday => box.values.where((w) => w.isKnown).length;

  final Random _random = Random();

  bool getRandomBool() {
    return _random.nextBool();
  }

  TaskType getRandomTaskType() {
    return TaskType.values[_random.nextInt(TaskType.values.length)];
  }

  // Генеруємо 3 неправильні варіанти + 1 правильний, перемішуємо
  List<String> generateOptions(Word word, bool foreignToNative) {
    final correct = foreignToNative ? word.ukrainian : word.english;
    final allTranslations = foreignToNative
        ? box.values.map((w) => w.ukrainian).toSet()
        : box.values.map((w) => w.english).toSet();

    allTranslations.remove(correct);

    final wrongOptions = allTranslations.toList()
      ..shuffle(_random)
      ..take(3);

    final options = [...wrongOptions, correct]..shuffle(_random);
    return options;
  }

  // Автоматична оцінка для typing/multiple choice (1–5)
  int ratingFromCorrectness(bool isCorrect) {
    return isCorrect ? 4 : 2; // можна налаштувати складніше
  }
}
