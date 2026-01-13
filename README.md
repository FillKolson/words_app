# LinguaFlash - Words Learning Application

## Project Overview

**LinguaFlash** is a Flutter-based mobile application designed for efficient vocabulary learning using spaced repetition algorithms. The app helps users learn English words with Ukrainian translations through interactive lessons.

## Project Structure

### Directory Layout

```
words_app/
├── lib/                           # Main application source code
│   ├── main.dart                 # Application entry point and MyApp widget
│   ├── models/                   # Data models
│   │   ├── word.dart            # Word model with Hive persistence
│   │   ├── word.g.dart          # Generated code for Hive adapter
│   │   └── task_type.dart       # Enum for task types (flipCard, multipleChoice, typing)
│   ├── providers/               # State management providers
│   │   └── word_provider.dart   # WordProvider for word data and business logic
│   └── screens/                 # UI screens
│       ├── auth_screen.dart     # Authentication screen
│       ├── home_screen.dart     # Home/dashboard screen
│       ├── lesson_screen.dart   # Lesson/learning screen
│       ├── main_screen.dart     # Main navigation screen
│       └── settings_screen.dart # Settings and statistics screen
│
├── test/                         # Unit tests
│   └── unit/
│       └── word_test.dart       # Unit tests for Word model
│
├── pubspec.yaml                 # Flutter dependencies and configuration
├── analysis_options.yaml        # Dart linter configuration
├── README.md                    # This file
└── .gitignore                  # Git ignore patterns
```

## Technology Stack

### Dependencies
- **Flutter 3.10.4+**
- **Provider 6.1.5+** - State management
- **Hive 2.2.3** - Local database
- **Firebase Auth 6.1.3** - User authentication
- **Intl 0.20.2** - Internationalization

### Dev Dependencies
- **flutter_test** - Widget and unit testing
- **mockito 4.4.4** - Mocking library for tests
- **integration_test** - Integration and E2E testing
- **hive_generator 2.0.1** - Code generation for Hive models
- **build_runner 2.4.8** - Build system

## Key Features

### Core Functionality
1. **Word Management** - Add and manage vocabulary
2. **Spaced Repetition** - Intelligent scheduling based on rating
3. **Multiple Question Types**:
   - Flip Card (visual memory)
   - Multiple Choice (recognition)
   - Typing (recall)
4. **Progress Tracking** - Monitor learning progress
5. **Daily Lessons** - Organized learning schedule

## Main Components and Their Responsibilities

### Models

#### Word (lib/models/word.dart)
- Represents a single vocabulary item
- Properties: english, ukrainian, difficulty, nextReview, isKnown
- **Key Method: `rate(int rating)`** - Updates word's difficulty and next review date based on spaced repetition algorithm

#### TaskType (lib/models/task_type.dart)
- Enum defining three types of learning tasks
- Values: flipCard, multipleChoice, typing

### Providers

#### WordProvider (lib/providers/word_provider.dart)
- Central business logic for word management
- Manages Hive database of words
- **Key Methods**:
  1. `loadTodayWords()` - Filters words ready for today's lesson
  2. `generateOptions(Word word, bool foreignToNative)` - Creates 4-answer multiple choice options
  3. `rateCurrent(int rating)` - Rates current word and moves to next
  4. `ratingFromCorrectness(bool isCorrect)` - Maps correct/incorrect to rating (1-5)
  5. `progress` - Calculates percentage of studied words
  6. `currentWord` - Returns first word from today's list

## Testing Strategy

### Unit Tests (test/unit/)

**5 нетривіальних функцій покриті тестами:**

#### Функція 1: `Word.rate(int rating)` - Система інтервального повторення
- **Призначення**: Оцінює рівень знання слова та планує наступну дату повторення
- **Вхідні дані**: rating (1-5)
- **Очікувані результати**:
  - rating >= 4 → isKnown = true (слово вивчене)
  - rating < 4 → nextReview = now + [1,2,4,7,14][rating-1] днів
- **Тести**: 5 тест-кейсів (1.1-1.5)

#### Функція 2: `Word Constructor` - Ініціалізація об'єкта Word
- **Призначення**: Створення нового об'єкта Word з параметрами
- **Вхідні дані**: english, ukrainian (обов'язкові); difficulty, nextReview, isKnown (опціональні)
- **Очікувані результати**:
  - Значення за замовчуванням: difficulty=3, isKnown=false
  - nextReview = DateTime.now() якщо не вказано
- **Тести**: 5 тест-кейсів (2.1-2.5)

#### Функція 3: `TaskType enum` - Типи завдань для вивчення
- **Призначення**: Enum визначає доступні типи завдань (flipCard, multipleChoice, typing)
- **Очікувані результати**:
  - Рівно 3 типи завдань
  - Унікальні індекси (0, 1, 2)
- **Тести**: 5 тест-кейсів (3.1-3.5)

#### Функція 4: `Word properties` - Властивості та мутабельність
- **Призначення**: Перевірка коректності зберігання та модифікації властивостей
- **Очікувані результати**:
  - Всі властивості мутабельні
  - Зміна однієї властивості не впливає на інші
  - Коректна робота з Unicode (кирилиця)
- **Тести**: 5 тест-кейсів (4.1-4.5)

#### Функція 5: `ratingFromCorrectness(bool isCorrect)` - Конвертація результату
- **Призначення**: Перетворює булевий результат відповіді в числову оцінку
- **Вхідні дані**: isCorrect (bool)
- **Очікувані результати**:
  - true → 4 (слово вивчене)
  - false → 2 (повторити через 2 дні)
- **Тести**: 5 тест-кейсів (5.1-5.5)

**Загалом**: 25 тест-кейсів для 5 функцій

**Coverage**: Word model class, TaskType enum - повне покриття основної логіки

## Running Tests

### Run all unit tests:
```bash
flutter test test/unit/
```

### Run with coverage report:
```bash
flutter test --coverage
```

### View coverage:
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# View report
open coverage/html/index.html
```

## Project Requirements Met

### Part 2: Test Automation - Забезпечення якості ПЗ

✅ **Репозиторій**
- Чиста історія git з осмисленими комітами
- .gitignore з Flutter-специфічними патернами
- README.md з описом структури проєкту та тестування

✅ **5 нетривіальних функцій з Unit-тестами**

| Функція | Призначення | Кількість тестів |
|---------|-------------|------------------|
| `Word.rate()` | Інтервальне повторення | 5 |
| `Word Constructor` | Ініціалізація об'єкта | 5 |
| `TaskType enum` | Типи завдань | 5 |
| `Word properties` | Мутабельність властивостей | 5 |
| `ratingFromCorrectness()` | Конвертація відповіді в оцінку | 5 |

✅ **Формат вимог у тестах**
- Кожна група тестів містить документацію:
  - Призначення функції
  - Вхідні дані
  - Очікувані результати
  - Граничні умови

✅ **Test Code Coverage**
- Команда: `flutter test --coverage`
- Звіт: `genhtml coverage/lcov.info -o coverage/html`

✅ **Тест-фреймворк**: flutter_test (вбудований у Flutter SDK)

## Development Workflow

### Adding a new test:
1. Create test file in appropriate directory (unit/integration/e2e)
2. Follow naming convention: `*_test.dart`
3. Run tests and verify coverage
4. Commit with message: `test: add [TestName] test`

### Making changes:
1. Implement feature/fix
2. Add corresponding tests
3. Run full test suite: `flutter test`
4. Generate coverage report
5. Commit with meaningful message

## Notes for QA Report

- All test files are located in `/test/unit` directory
- Each test group includes detailed requirements in documentation comments
- Test requirements describe:
  - Input conditions
  - Expected output
  - Acceptance criteria
- Test code coverage can be generated using `flutter test --coverage`
- All commits should be atomic and demonstrate clear progress

## Future Enhancements

- [ ] Add authentication flow E2E tests
- [ ] Implement performance benchmarks
- [ ] Add UI widget tests for all screens
- [ ] Expand test coverage to 80%+
- [ ] Add CI/CD integration

## Contact & Support

For questions about the test implementation, refer to the individual test files and their documentation comments.


