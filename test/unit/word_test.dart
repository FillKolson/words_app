import 'package:flutter_test/flutter_test.dart';
import 'package:words_app/models/word.dart';

void main() {
  group('Word Model Tests', () {
    late Word testWord;

    setUp(() {
      testWord = Word(
        english: 'hello',
        ukrainian: 'привіт',
        difficulty: 1,
        isKnown: false,
      );
    });

    /// Вимога 1: Функція rate() повинна коректно встановлювати статус isKnown
    /// та розраховувати наступну дату перегляду залежно від рейтингу
    /// 
    /// Вхідні дані:
    /// - Word з initial difficulty 1, isKnown = false
    /// - Рейтинги: 1 (слабо), 2 (нормально), 3 (добре), 4+ (відлично)
    /// 
    /// Очікувані результати:
    /// - При rating >= 4: isKnown = true, слово більше не потребує перегляду
    /// - При rating < 4: isKnown = false, nextReview розраховується як:
    ///   rating 1 → 1 день, rating 2 → 2 дні, rating 3 → 4 дні
    group('UNIT TEST 1: rate() - word review scheduling', () {
      test('rate(4) should set isKnown to true', () {
        testWord.rate(4);
        expect(testWord.isKnown, isTrue);
      });

      test('rate(5) should set isKnown to true', () {
        testWord.rate(5);
        expect(testWord.isKnown, isTrue);
      });

      test('rate(1) should keep isKnown false and schedule 1 day review', () {
        final beforeRate = DateTime.now();
        testWord.rate(1);
        final afterRate = DateTime.now();

        expect(testWord.isKnown, isFalse);
        expect(testWord.nextReview.isAfter(beforeRate), isTrue);
        expect(testWord.nextReview.isBefore(afterRate.add(Duration(days: 2))), isTrue);
      });

      test('rate(2) should schedule 2 days review', () {
        final beforeRate = DateTime.now();
        testWord.rate(2);
        final afterRate = DateTime.now();

        expect(testWord.isKnown, isFalse);
        expect(testWord.nextReview.isAfter(beforeRate.add(Duration(days: 1))), isTrue);
      });

      test('rate(3) should schedule 4 days review', () {
        final beforeRate = DateTime.now();
        testWord.rate(3);
        final afterRate = DateTime.now();

        expect(testWord.isKnown, isFalse);
        expect(testWord.nextReview.isAfter(beforeRate.add(Duration(days: 3))), isTrue);
      });
    });
  });
}
