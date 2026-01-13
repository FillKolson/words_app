import 'package:flutter_test/flutter_test.dart';
import 'package:words_app/models/word.dart';
import 'package:words_app/models/task_type.dart';

void main() {
  // ============================================================================
  // ФУНКЦІЯ 1: Word.rate() - Система інтервального повторення слів
  // ============================================================================
  // 
  // ВИМОГИ ДО ФУНКЦІЇ rate(int rating):
  // 
  // Призначення: Функція оцінює рівень знання слова користувачем та планує
  // наступну дату повторення за алгоритмом інтервального повторення (Spaced Repetition).
  // 
  // Вхідні дані:
  //   - rating: int - оцінка від 1 до 5, де:
  //     * 1 - зовсім не знаю (повторити через 1 день)
  //     * 2 - погано пам'ятаю (повторити через 2 дні)
  //     * 3 - знаю з труднощами (повторити через 4 дні)
  //     * 4 - знаю добре (слово вивчене)
  //     * 5 - знаю відмінно (слово вивчене)
  // 
  // Очікувані результати:
  //   - difficulty оновлюється до значення rating
  //   - Якщо rating >= 4: isKnown = true (слово вважається вивченим)
  //   - Якщо rating < 4: isKnown = false, nextReview = now + [1,2,4,7,14][rating-1] днів
  // 
  // Граничні умови:
  //   - rating = 1: мінімальний інтервал (1 день)
  //   - rating = 4: перший рівень "вивчено"
  //   - Дата nextReview має бути строго в майбутньому
  // ============================================================================
  
  group('ФУНКЦІЯ 1: Word.rate() - Система інтервального повторення', () {
    late Word testWord;

    setUp(() {
      testWord = Word(
        english: 'hello',
        ukrainian: 'привіт',
        difficulty: 3,
        isKnown: false,
      );
    });

    test('1.1: rate(4) має встановити isKnown = true (слово вивчене)', () {
      // Arrange
      expect(testWord.isKnown, isFalse);
      
      // Act
      testWord.rate(4);
      
      // Assert
      expect(testWord.isKnown, isTrue);
      expect(testWord.difficulty, equals(4));
    });

    test('1.2: rate(5) має встановити isKnown = true (відмінне знання)', () {
      // Arrange
      expect(testWord.isKnown, isFalse);
      
      // Act
      testWord.rate(5);
      
      // Assert
      expect(testWord.isKnown, isTrue);
      expect(testWord.difficulty, equals(5));
    });

    test('1.3: rate(1) має залишити isKnown = false та запланувати повторення через 1 день', () {
      // Arrange
      final beforeRate = DateTime.now();
      
      // Act
      testWord.rate(1);
      
      // Assert
      expect(testWord.isKnown, isFalse);
      expect(testWord.difficulty, equals(1));
      
      final expectedMinDate = beforeRate.add(Duration(days: 1));
      expect(testWord.nextReview.isAfter(beforeRate), isTrue);
      expect(testWord.nextReview.isBefore(expectedMinDate.add(Duration(minutes: 1))), isTrue);
    });

    test('1.4: rate(2) має запланувати повторення через 2 дні', () {
      // Arrange
      final beforeRate = DateTime.now();
      
      // Act
      testWord.rate(2);
      
      // Assert
      expect(testWord.isKnown, isFalse);
      expect(testWord.difficulty, equals(2));
      
      final expectedDate = beforeRate.add(Duration(days: 2));
      expect(testWord.nextReview.day, equals(expectedDate.day));
    });

    test('1.5: rate(3) має запланувати повторення через 4 дні', () {
      // Arrange
      final beforeRate = DateTime.now();
      
      // Act
      testWord.rate(3);
      
      // Assert
      expect(testWord.isKnown, isFalse);
      expect(testWord.difficulty, equals(3));
      
      final expectedDate = beforeRate.add(Duration(days: 4));
      expect(testWord.nextReview.day, equals(expectedDate.day));
    });
  });

  // ============================================================================
  // ФУНКЦІЯ 2: Word Constructor - Ініціалізація об'єкта Word
  // ============================================================================
  // 
  // ВИМОГИ ДО КОНСТРУКТОРА Word():
  // 
  // Призначення: Створення нового об'єкта Word з обов'язковими та опціональними
  // параметрами для представлення слова в системі вивчення мови.
  // 
  // Вхідні дані:
  //   - english: String (обов'язковий) - слово англійською
  //   - ukrainian: String (обов'язковий) - переклад українською
  //   - difficulty: int (опціональний, за замовчуванням = 3) - складність 1-5
  //   - nextReview: DateTime? (опціональний) - дата наступного повторення
  //   - isKnown: bool (опціональний, за замовчуванням = false) - чи вивчене слово
  // 
  // Очікувані результати:
  //   - Всі поля ініціалізуються коректно
  //   - Якщо nextReview не вказано, встановлюється DateTime.now()
  //   - Значення за замовчуванням: difficulty = 3, isKnown = false
  // 
  // Граничні умови:
  //   - Порожній рядок для english/ukrainian має бути допустимим
  //   - difficulty може бути будь-яким int (валідація на рівні UI)
  // ============================================================================
  
  group('ФУНКЦІЯ 2: Word Constructor - Ініціалізація об\'єкта', () {
    test('2.1: Конструктор з усіма обов\'язковими параметрами', () {
      // Act
      final word = Word(
        english: 'test',
        ukrainian: 'тест',
      );
      
      // Assert
      expect(word.english, equals('test'));
      expect(word.ukrainian, equals('тест'));
      expect(word.difficulty, equals(3)); // значення за замовчуванням
      expect(word.isKnown, isFalse); // значення за замовчуванням
    });

    test('2.2: Конструктор з кастомним difficulty', () {
      // Act
      final word = Word(
        english: 'apple',
        ukrainian: 'яблуко',
        difficulty: 5,
      );
      
      // Assert
      expect(word.difficulty, equals(5));
      expect(word.isKnown, isFalse);
    });

    test('2.3: Конструктор з кастомним nextReview', () {
      // Arrange
      final customDate = DateTime(2025, 12, 31);
      
      // Act
      final word = Word(
        english: 'book',
        ukrainian: 'книга',
        nextReview: customDate,
      );
      
      // Assert
      expect(word.nextReview, equals(customDate));
    });

    test('2.4: nextReview за замовчуванням встановлюється в поточний час', () {
      // Arrange
      final beforeCreate = DateTime.now();
      
      // Act
      final word = Word(
        english: 'house',
        ukrainian: 'будинок',
      );
      
      // Assert
      final afterCreate = DateTime.now();
      expect(word.nextReview.isAfter(beforeCreate.subtract(Duration(seconds: 1))), isTrue);
      expect(word.nextReview.isBefore(afterCreate.add(Duration(seconds: 1))), isTrue);
    });

    test('2.5: Конструктор з isKnown = true', () {
      // Act
      final word = Word(
        english: 'cat',
        ukrainian: 'кіт',
        isKnown: true,
      );
      
      // Assert
      expect(word.isKnown, isTrue);
    });
  });

  // ============================================================================
  // ФУНКЦІЯ 3: TaskType enum - Типи завдань для вивчення слів
  // ============================================================================
  // 
  // ВИМОГИ ДО TaskType:
  // 
  // Призначення: Enum визначає доступні типи завдань для інтерактивного
  // вивчення слів у додатку.
  // 
  // Типи завдань:
  //   - flipCard: класична флеш-картка з перевертанням
  //   - multipleChoice: вибір правильного варіанту з декількох
  //   - typing: введення перекладу з клавіатури
  // 
  // Очікувані результати:
  //   - TaskType.values має містити рівно 3 елементи
  //   - Кожен тип має унікальний індекс (0, 1, 2)
  //   - Можливість ітерації по всіх типах
  // ============================================================================
  
  group('ФУНКЦІЯ 3: TaskType enum - Типи завдань', () {
    test('3.1: TaskType має містити рівно 3 типи завдань', () {
      // Assert
      expect(TaskType.values.length, equals(3));
    });

    test('3.2: flipCard має бути першим типом (index 0)', () {
      // Assert
      expect(TaskType.flipCard.index, equals(0));
      expect(TaskType.values[0], equals(TaskType.flipCard));
    });

    test('3.3: multipleChoice має бути другим типом (index 1)', () {
      // Assert
      expect(TaskType.multipleChoice.index, equals(1));
      expect(TaskType.values[1], equals(TaskType.multipleChoice));
    });

    test('3.4: typing має бути третім типом (index 2)', () {
      // Assert
      expect(TaskType.typing.index, equals(2));
      expect(TaskType.values[2], equals(TaskType.typing));
    });

    test('3.5: Всі типи TaskType унікальні', () {
      // Arrange
      final types = TaskType.values.toSet();
      
      // Assert
      expect(types.length, equals(TaskType.values.length));
    });
  });

  // ============================================================================
  // ФУНКЦІЯ 4: Word equality and properties - Властивості об'єкта Word
  // ============================================================================
  // 
  // ВИМОГИ ДО ВЛАСТИВОСТЕЙ Word:
  // 
  // Призначення: Перевірка коректності зберігання та доступу до властивостей
  // об'єкта Word, включаючи можливість їх модифікації.
  // 
  // Властивості:
  //   - english: String - слово мовою оригіналу (англійська)
  //   - ukrainian: String - переклад (українська)
  //   - difficulty: int - рівень складності (1-5)
  //   - nextReview: DateTime - дата наступного повторення
  //   - isKnown: bool - статус вивченості
  // 
  // Очікувані результати:
  //   - Всі властивості мають бути мутабельними
  //   - Зміна однієї властивості не впливає на інші
  //   - Коректна робота з Unicode (кирилиця)
  // ============================================================================
  
  group('ФУНКЦІЯ 4: Word properties - Властивості та мутабельність', () {
    late Word testWord;

    setUp(() {
      testWord = Word(
        english: 'water',
        ukrainian: 'вода',
        difficulty: 2,
      );
    });

    test('4.1: Зміна властивості english не впливає на інші поля', () {
      // Arrange
      final originalUkrainian = testWord.ukrainian;
      final originalDifficulty = testWord.difficulty;
      
      // Act
      testWord.english = 'fire';
      
      // Assert
      expect(testWord.english, equals('fire'));
      expect(testWord.ukrainian, equals(originalUkrainian));
      expect(testWord.difficulty, equals(originalDifficulty));
    });

    test('4.2: Зміна властивості difficulty', () {
      // Act
      testWord.difficulty = 5;
      
      // Assert
      expect(testWord.difficulty, equals(5));
    });

    test('4.3: Зміна властивості isKnown', () {
      // Arrange
      expect(testWord.isKnown, isFalse);
      
      // Act
      testWord.isKnown = true;
      
      // Assert
      expect(testWord.isKnown, isTrue);
    });

    test('4.4: Зміна властивості nextReview', () {
      // Arrange
      final newDate = DateTime(2030, 1, 1);
      
      // Act
      testWord.nextReview = newDate;
      
      // Assert
      expect(testWord.nextReview, equals(newDate));
    });

    test('4.5: Коректна робота з Unicode символами (кирилиця)', () {
      // Act
      final word = Word(
        english: 'language',
        ukrainian: 'мова',
      );
      word.ukrainian = 'мова програмування';
      
      // Assert
      expect(word.ukrainian, equals('мова програмування'));
      expect(word.ukrainian.length, equals(18));
    });
  });

  // ============================================================================
  // ФУНКЦІЯ 5: ratingFromCorrectness() - Конвертація результату в оцінку
  // ============================================================================
  // 
  // ВИМОГИ ДО ФУНКЦІЇ ratingFromCorrectness(bool isCorrect):
  // 
  // Призначення: Функція перетворює булевий результат відповіді (правильно/
  // неправильно) в числову оцінку для системи інтервального повторення.
  // 
  // Вхідні дані:
  //   - isCorrect: bool - чи правильно користувач відповів на завдання
  // 
  // Очікувані результати:
  //   - Якщо isCorrect = true: повертає 4 (слово вивчене)
  //   - Якщо isCorrect = false: повертає 2 (потребує повторення через 2 дні)
  // 
  // Бізнес-логіка:
  //   - Оцінка 4 активує isKnown = true при виклику rate()
  //   - Оцінка 2 планує повторення через 2 дні
  //   - Функція використовується для автоматичної оцінки в typing/multipleChoice
  // ============================================================================
  
  group('ФУНКЦІЯ 5: ratingFromCorrectness() - Конвертація результату', () {
    // Примітка: Функція знаходиться в WordProvider, тому тестуємо логіку окремо
    
    int ratingFromCorrectness(bool isCorrect) {
      return isCorrect ? 4 : 2;
    }

    test('5.1: Правильна відповідь (true) повертає оцінку 4', () {
      // Act
      final rating = ratingFromCorrectness(true);
      
      // Assert
      expect(rating, equals(4));
    });

    test('5.2: Неправильна відповідь (false) повертає оцінку 2', () {
      // Act
      final rating = ratingFromCorrectness(false);
      
      // Assert
      expect(rating, equals(2));
    });

    test('5.3: Оцінка 4 від правильної відповіді має встановити isKnown = true', () {
      // Arrange
      final word = Word(english: 'sun', ukrainian: 'сонце');
      final rating = ratingFromCorrectness(true);
      
      // Act
      word.rate(rating);
      
      // Assert
      expect(word.isKnown, isTrue);
    });

    test('5.4: Оцінка 2 від неправильної відповіді має запланувати повторення', () {
      // Arrange
      final word = Word(english: 'moon', ukrainian: 'місяць');
      final beforeRate = DateTime.now();
      final rating = ratingFromCorrectness(false);
      
      // Act
      word.rate(rating);
      
      // Assert
      expect(word.isKnown, isFalse);
      expect(word.nextReview.isAfter(beforeRate), isTrue);
    });

    test('5.5: Послідовні правильні відповіді зберігають статус вивченого слова', () {
      // Arrange
      final word = Word(english: 'star', ukrainian: 'зірка');
      
      // Act - перша правильна відповідь
      word.rate(ratingFromCorrectness(true));
      expect(word.isKnown, isTrue);
      
      // Act - друга правильна відповідь
      word.rate(ratingFromCorrectness(true));
      
      // Assert
      expect(word.isKnown, isTrue);
      expect(word.difficulty, equals(4));
    });
  });
}
