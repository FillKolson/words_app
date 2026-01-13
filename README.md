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

