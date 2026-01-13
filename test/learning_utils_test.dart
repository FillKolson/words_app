import 'package:flutter_test/flutter_test.dart';
import 'package:words_app/utils/learning_utils.dart';

void main() {
  group('Review Date Calculation', () {
    test('should calculate next review date for rating 1 (1 day)', () {
      final now = DateTime.now();
      final nextReview = calculateNextReviewDate(1);
      final difference = nextReview.difference(now).inDays;
      expect(difference, 1);
    });

    test('should calculate next review date for rating 2 (2 days)', () {
      final now = DateTime.now();
      final nextReview = calculateNextReviewDate(2);
      final difference = nextReview.difference(now).inDays;
      expect(difference, 2);
    });

    test('should calculate next review date for rating 3 (4 days)', () {
      final now = DateTime.now();
      final nextReview = calculateNextReviewDate(3);
      final difference = nextReview.difference(now).inDays;
      expect(difference, 4);
    });

    test('should calculate next review date for rating 4 (7 days)', () {
      final now = DateTime.now();
      final nextReview = calculateNextReviewDate(4);
      final difference = nextReview.difference(now).inDays;
      expect(difference, 7);
    });

    test('should calculate next review date for rating 5 (14 days)', () {
      final now = DateTime.now();
      final nextReview = calculateNextReviewDate(5);
      final difference = nextReview.difference(now).inDays;
      expect(difference, 14);
    });

    test('should throw error for invalid rating 0', () {
      expect(() => calculateNextReviewDate(0), throwsArgumentError);
    });

    test('should throw error for invalid rating 6', () {
      expect(() => calculateNextReviewDate(6), throwsArgumentError);
    });
  });

  group('Word Known Status', () {
    test('should mark word as known for rating 4', () {
      expect(isWordKnown(4), true);
    });

    test('should mark word as known for rating 5', () {
      expect(isWordKnown(5), true);
    });

    test('should not mark word as known for rating 1', () {
      expect(isWordKnown(1), false);
    });

    test('should not mark word as known for rating 2', () {
      expect(isWordKnown(2), false);
    });

    test('should not mark word as known for rating 3', () {
      expect(isWordKnown(3), false);
    });
  });

  group('Progress Calculation', () {
    test('should return 0% when no words are studied', () {
      expect(calculateProgress(0, 10), 0.0);
    });

    test('should return 100% when all words are known', () {
      expect(calculateProgress(10, 10), 100.0);
    });

    test('should return 50% when half words are known', () {
      expect(calculateProgress(5, 10), 50.0);
    });

    test('should return 0% when total words is 0', () {
      expect(calculateProgress(5, 0), 0.0);
    });

    test('should calculate correct percentage', () {
      expect(calculateProgress(3, 20), 15.0);
    });
  });

  group('Daily Progress Calculation', () {
    test('should return 0% when no words studied', () {
      expect(calculateDailyProgress(0, goal: 10), 0.0);
    });

    test('should return 50% when half goal achieved', () {
      expect(calculateDailyProgress(5, goal: 10), 50.0);
    });

    test('should return 100% when goal is reached', () {
      expect(calculateDailyProgress(10, goal: 10), 100.0);
    });

    test('should return 100% when goal is exceeded', () {
      expect(calculateDailyProgress(15, goal: 10), 100.0);
    });

    test('should work with custom goal', () {
      expect(calculateDailyProgress(5, goal: 20), 25.0);
    });
  });

  group('Difficulty Level Conversion', () {
    test('should convert rating 1 to easy', () {
      expect(getDifficultyLevel(1), Difficulty.easy);
    });

    test('should convert rating 2 to normal', () {
      expect(getDifficultyLevel(2), Difficulty.normal);
    });

    test('should convert rating 3 to hard', () {
      expect(getDifficultyLevel(3), Difficulty.hard);
    });

    test('should convert rating 4 to veryHard', () {
      expect(getDifficultyLevel(4), Difficulty.veryHard);
    });

    test('should convert rating 5 to extreme', () {
      expect(getDifficultyLevel(5), Difficulty.extreme);
    });

    test('should throw error for invalid rating', () {
      expect(() => getDifficultyLevel(0), throwsArgumentError);
    });
  });

  group('Difficulty to Rating Conversion', () {
    test('should convert easy to 1', () {
      expect(getRatingFromDifficulty(Difficulty.easy), 1);
    });

    test('should convert normal to 2', () {
      expect(getRatingFromDifficulty(Difficulty.normal), 2);
    });

    test('should convert hard to 3', () {
      expect(getRatingFromDifficulty(Difficulty.hard), 3);
    });

    test('should convert veryHard to 4', () {
      expect(getRatingFromDifficulty(Difficulty.veryHard), 4);
    });

    test('should convert extreme to 5', () {
      expect(getRatingFromDifficulty(Difficulty.extreme), 5);
    });
  });

  group('Duration Formatting', () {
    test('should format 1 day correctly', () {
      final duration = Duration(days: 1);
      expect(formatDuration(duration), '1 day');
    });

    test('should format multiple days correctly', () {
      final duration = Duration(days: 5);
      expect(formatDuration(duration), '5 days');
    });

    test('should format 1 hour correctly', () {
      final duration = Duration(hours: 1);
      expect(formatDuration(duration), '1 hour');
    });

    test('should format multiple hours correctly', () {
      final duration = Duration(hours: 3);
      expect(formatDuration(duration), '3 hours');
    });

    test('should format 1 minute correctly', () {
      final duration = Duration(minutes: 1);
      expect(formatDuration(duration), '1 minute');
    });

    test('should format multiple minutes correctly', () {
      final duration = Duration(minutes: 30);
      expect(formatDuration(duration), '30 minutes');
    });

    test('should format less than 1 minute', () {
      final duration = Duration(seconds: 30);
      expect(formatDuration(duration), 'Just now');
    });

    test('should prioritize days over hours', () {
      final duration = Duration(days: 1, hours: 5);
      expect(formatDuration(duration), '1 day');
    });
  });
}
