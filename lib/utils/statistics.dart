/// Statistics and analytics functions for learning progress

/// Calculates average rating from a list of ratings
/// Returns 0 if list is empty
double calculateAverageRating(List<int> ratings) {
  if (ratings.isEmpty) return 0.0;
  final sum = ratings.reduce((a, b) => a + b);
  return sum / ratings.length;
}

/// Calculates accuracy percentage (correct answers / total answers * 100)
double calculateAccuracy(int correct, int total) {
  if (total == 0) return 0.0;
  if (correct > total) return 100.0;
  return (correct / total) * 100;
}

/// Groups words by rating and returns count for each rating
/// Returns a map with keys 1-5 and their counts
Map<int, int> groupWordsByRating(List<int> ratings) {
  final grouped = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  for (final rating in ratings) {
    if (rating >= 1 && rating <= 5) {
      grouped[rating] = (grouped[rating] ?? 0) + 1;
    }
  }

  return grouped;
}

/// Finds the longest streak of correct answers
/// Example: [true, true, false, true, true] -> 2
int getBestStreak(List<bool> results) {
  if (results.isEmpty) return 0;

  int maxStreak = 0;
  int currentStreak = 0;

  for (final result in results) {
    if (result) {
      currentStreak++;
      maxStreak = maxStreak < currentStreak ? currentStreak : maxStreak;
    } else {
      currentStreak = 0;
    }
  }

  return maxStreak;
}

/// Calculates total streak length (consecutive results)
int getCurrentStreak(List<bool> results) {
  if (results.isEmpty) return 0;

  int streak = 0;
  for (int i = results.length - 1; i >= 0; i--) {
    if (results[i]) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

/// Calculates word distribution across difficulty levels
Map<String, int> getWordDistribution(List<int> ratings) {
  return {
    'easy': ratings.where((r) => r == 1).length,
    'normal': ratings.where((r) => r == 2).length,
    'hard': ratings.where((r) => r == 3).length,
    'veryHard': ratings.where((r) => r == 4).length,
    'extreme': ratings.where((r) => r == 5).length,
  };
}

/// Calculates learning velocity (words learned per day)
double calculateLearningVelocity(int wordsLearned, int daysSpent) {
  if (daysSpent == 0) return 0.0;
  return wordsLearned / daysSpent;
}

/// Predicts days needed to learn all words based on current velocity
int predictDaysToLearnAll(
  int totalWords,
  int knownWords,
  double dailyLearningRate,
) {
  if (dailyLearningRate <= 0) return 0;
  final remainingWords = totalWords - knownWords;
  return (remainingWords / dailyLearningRate).ceil();
}

/// Calculates consistency score (0-100) based on recent results
/// More recent results have higher weight
double calculateConsistencyScore(List<bool> results) {
  if (results.isEmpty) return 0.0;

  // Use last 10 results or all if less than 10
  final recentResults = results.length > 10
      ? results.sublist(results.length - 10)
      : results;

  final trueCount = recentResults.where((r) => r).length;
  return (trueCount / recentResults.length) * 100;
}

/// Gets motivational message based on daily progress
String getMotivationalMessage(double dailyProgress) {
  if (dailyProgress >= 100) {
    return '🎉 Amazing! You exceeded your daily goal!';
  } else if (dailyProgress >= 75) {
    return '🔥 Almost there! Keep up the momentum!';
  } else if (dailyProgress >= 50) {
    return '💪 Good progress! Keep going!';
  } else if (dailyProgress >= 25) {
    return '📚 Nice start! Let\'s continue!';
  } else if (dailyProgress > 0) {
    return '✨ Every step counts! Begin your learning!';
  }
  return '🚀 Ready to learn? Start now!';
}

/// Calculates the difficulty increase trend
/// Positive = getting harder, Negative = getting easier
double calculateDifficultyTrend(List<int> recentRatings) {
  if (recentRatings.length < 2) return 0.0;

  final firstHalf = recentRatings.sublist(
    0,
    (recentRatings.length / 2).floor(),
  );
  final secondHalf = recentRatings.sublist((recentRatings.length / 2).floor());

  final avgFirst = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
  final avgSecond = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

  return avgSecond - avgFirst;
}
