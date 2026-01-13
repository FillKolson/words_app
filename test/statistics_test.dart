import 'package:flutter_test/flutter_test.dart';
import 'package:words_app/utils/statistics.dart';

void main() {
  group('Average Rating Calculation', () {
    test('should return 0 for empty list', () {
      expect(calculateAverageRating([]), 0.0);
    });

    test('should calculate average for single rating', () {
      expect(calculateAverageRating([3]), 3.0);
    });

    test('should calculate average for multiple ratings', () {
      expect(calculateAverageRating([1, 2, 3, 4, 5]), 3.0);
    });

    test('should calculate average correctly', () {
      expect(calculateAverageRating([2, 4]), 3.0);
    });

    test('should handle all same ratings', () {
      expect(calculateAverageRating([4, 4, 4, 4]), 4.0);
    });

    test('should calculate decimal average', () {
      expect(calculateAverageRating([1, 2]), 1.5);
    });
  });

  group('Accuracy Calculation', () {
    test('should return 0% when total is 0', () {
      expect(calculateAccuracy(0, 0), 0.0);
    });

    test('should return 0% when no correct answers', () {
      expect(calculateAccuracy(0, 10), 0.0);
    });

    test('should return 100% when all correct', () {
      expect(calculateAccuracy(10, 10), 100.0);
    });

    test('should return 50% for half correct', () {
      expect(calculateAccuracy(5, 10), 50.0);
    });

    test('should cap at 100% when correct > total', () {
      expect(calculateAccuracy(15, 10), 100.0);
    });

    test('should calculate decimal percentage', () {
      expect(calculateAccuracy(1, 3), closeTo(33.33, 0.01));
    });

    test('should calculate 25% accuracy', () {
      expect(calculateAccuracy(1, 4), 25.0);
    });
  });

  group('Group Words By Rating', () {
    test('should return all zeros for empty list', () {
      final result = groupWordsByRating([]);
      expect(result, {1: 0, 2: 0, 3: 0, 4: 0, 5: 0});
    });

    test('should count ratings correctly', () {
      final result = groupWordsByRating([1, 1, 2, 3, 3, 3, 5]);
      expect(result[1], 2);
      expect(result[2], 1);
      expect(result[3], 3);
      expect(result[4], 0);
      expect(result[5], 1);
    });

    test('should handle single rating', () {
      final result = groupWordsByRating([3]);
      expect(result[3], 1);
      expect(result[1], 0);
    });

    test('should distribute across all ratings', () {
      final result = groupWordsByRating([1, 2, 3, 4, 5]);
      expect(result, {1: 1, 2: 1, 3: 1, 4: 1, 5: 1});
    });

    test('should ignore invalid ratings', () {
      final result = groupWordsByRating([1, 2, 6, 0, 3]);
      expect(result[1], 1);
      expect(result[2], 1);
      expect(result[3], 1);
      expect(result[4], 0);
    });
  });

  group('Best Streak Calculation', () {
    test('should return 0 for empty list', () {
      expect(getBestStreak([]), 0);
    });

    test('should return 1 for single true', () {
      expect(getBestStreak([true]), 1);
    });

    test('should return 0 for single false', () {
      expect(getBestStreak([false]), 0);
    });

    test('should find streak at start', () {
      expect(getBestStreak([true, true, false, false]), 2);
    });

    test('should find streak in middle', () {
      expect(getBestStreak([false, true, true, true, false]), 3);
    });

    test('should find streak at end', () {
      expect(getBestStreak([false, false, true, true, true]), 3);
    });

    test('should find longest streak among multiple', () {
      expect(
        getBestStreak([true, true, false, true, true, true, false, true]),
        3,
      );
    });

    test('should handle all true', () {
      expect(getBestStreak([true, true, true, true]), 4);
    });

    test('should handle all false', () {
      expect(getBestStreak([false, false, false]), 0);
    });
  });

  group('Current Streak Calculation', () {
    test('should return 0 for empty list', () {
      expect(getCurrentStreak([]), 0);
    });

    test('should return current streak at end', () {
      expect(getCurrentStreak([false, true, true, true]), 3);
    });

    test('should return 0 if last is false', () {
      expect(getCurrentStreak([true, true, false]), 0);
    });

    test('should count all if all true', () {
      expect(getCurrentStreak([true, true, true]), 3);
    });
  });

  group('Word Distribution', () {
    test('should return zero distribution for empty list', () {
      final result = getWordDistribution([]);
      expect(result['easy'], 0);
      expect(result['extreme'], 0);
    });

    test('should distribute words correctly', () {
      final result = getWordDistribution([1, 1, 2, 3, 4, 5]);
      expect(result['easy'], 2);
      expect(result['normal'], 1);
      expect(result['hard'], 1);
      expect(result['veryHard'], 1);
      expect(result['extreme'], 1);
    });

    test('should return 0 for missing difficulty levels', () {
      final result = getWordDistribution([1, 1, 1]);
      expect(result['easy'], 3);
      expect(result['normal'], 0);
      expect(result['extreme'], 0);
    });
  });

  group('Learning Velocity', () {
    test('should return 0 for 0 days spent', () {
      expect(calculateLearningVelocity(10, 0), 0.0);
    });

    test('should calculate words per day', () {
      expect(calculateLearningVelocity(10, 5), 2.0);
    });

    test('should handle decimal velocity', () {
      expect(calculateLearningVelocity(5, 3), closeTo(1.67, 0.01));
    });

    test('should calculate single day velocity', () {
      expect(calculateLearningVelocity(7, 1), 7.0);
    });
  });

  group('Predict Days To Learn All', () {
    test('should return 0 for zero learning rate', () {
      expect(predictDaysToLearnAll(100, 50, 0), 0);
    });

    test('should calculate days needed', () {
      expect(predictDaysToLearnAll(100, 50, 5), 10);
    });

    test('should round up fractional days', () {
      expect(predictDaysToLearnAll(100, 50, 3), 17);
    });

    test('should return 0 when all words known', () {
      expect(predictDaysToLearnAll(50, 50, 5), 0);
    });

    test('should handle single word remaining', () {
      expect(predictDaysToLearnAll(10, 9, 1), 1);
    });
  });

  group('Consistency Score', () {
    test('should return 0 for empty list', () {
      expect(calculateConsistencyScore([]), 0.0);
    });

    test('should return 100 for all true', () {
      expect(calculateConsistencyScore([true, true, true]), 100.0);
    });

    test('should return 0 for all false', () {
      expect(calculateConsistencyScore([false, false, false]), 0.0);
    });

    test('should calculate 50% consistency', () {
      expect(calculateConsistencyScore([true, false, true, false]), 50.0);
    });

    test('should use only last 10 results', () {
      final results = List<bool>.filled(20, false);
      results[19] = true;
      results[18] = true;
      final score = calculateConsistencyScore(results);
      expect(score, 20.0); // 2 out of 10
    });
  });

  group('Motivational Messages', () {
    test('should return exceeded message for 100%+', () {
      expect(getMotivationalMessage(100.0), contains('🎉'));
    });

    test('should return great message for 75-99%', () {
      expect(getMotivationalMessage(80.0), contains('🔥'));
    });

    test('should return good message for 50-74%', () {
      expect(getMotivationalMessage(60.0), contains('💪'));
    });

    test('should return okay message for 25-49%', () {
      expect(getMotivationalMessage(30.0), contains('📚'));
    });

    test('should return start message for 1-24%', () {
      expect(getMotivationalMessage(10.0), contains('✨'));
    });

    test('should return ready message for 0%', () {
      expect(getMotivationalMessage(0.0), contains('🚀'));
    });
  });

  group('Difficulty Trend', () {
    test('should return 0 for less than 2 ratings', () {
      expect(calculateDifficultyTrend([]), 0.0);
      expect(calculateDifficultyTrend([3]), 0.0);
    });

    test('should return positive trend when getting harder', () {
      final trend = calculateDifficultyTrend([1, 1, 1, 5, 5, 5]);
      expect(trend, greaterThan(0));
    });

    test('should return negative trend when getting easier', () {
      final trend = calculateDifficultyTrend([5, 5, 5, 1, 1, 1]);
      expect(trend, lessThan(0));
    });

    test('should return 0 for consistent difficulty', () {
      final trend = calculateDifficultyTrend([3, 3, 3, 3, 3, 3]);
      expect(trend, 0.0);
    });

    test('should handle two ratings', () {
      final trend = calculateDifficultyTrend([2, 4]);
      expect(trend, 2.0);
    });
  });
}
