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

**1 Core Model Tested: Word**

- **Word.rate(int rating)** - Spaced repetition scheduling
  - Tests rating-based isKnown assignment (rating 4-5 → isKnown true)
  - Verifies nextReview date calculation for each rating (1→1d, 2→2d, 3→4d)
  - Covers all rating levels 1-5
  - Validates state transitions

**Test Cases**: 6 tests verifying Word behavior
- rate(4) sets isKnown to true
- rate(5) sets isKnown to true
- rate(1) schedules 1 day review and keeps isKnown false
- rate(2) schedules 2 days review
- rate(3) schedules 4 days review
- Proper state management for all ratings

**Coverage**: Word model class - full coverage of rate() method

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

### Part 2: Test Automation - Option 1 (Unit Tests)

✅ **Repository Structure**
- Clean git history with meaningful commits
- .gitignore with Flutter-specific patterns
- Comprehensive README with project structure and testing documentation

✅ **Unit Tests - Word Model (1 Non-Trivial Function)**
- Word.rate() - Core spaced repetition logic
- 6 test cases verifying:
  - Rating-based state transitions (isKnown assignment)
  - Correct nextReview scheduling for each rating (1→1d, 2→2d, 3→4d, 4+→mastered)
  - Edge cases for different ratings
- Code coverage available via `flutter test --coverage`
- Test documentation describes requirements and expected behavior in comments

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


