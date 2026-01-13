/// Functions for working with learning tasks

/// Difficulty levels for words
enum Difficulty { easy, normal, hard, veryHard, extreme }

/// Calculates the next review date based on difficulty rating (1-5)
DateTime calculateNextReviewDate(int rating) {
  if (rating < 1 || rating > 5) {
    throw ArgumentError('Rating must be between 1 and 5');
  }

  const dayIntervals = [1, 2, 4, 7, 14];
  final daysToAdd = dayIntervals[rating - 1];
  return DateTime.now().add(Duration(days: daysToAdd));
}

/// Determines if a word should be marked as known
bool isWordKnown(int rating) {
  return rating >= 4;
}

/// Calculates progress percentage
double calculateProgress(int knownWords, int totalWords) {
  if (totalWords == 0) return 0.0;
  return (knownWords / totalWords) * 100;
}

/// Calculates daily goal completion percentage
/// Completed: number of words studied today
/// Goal: daily goal (default 10)
double calculateDailyProgress(int completed, {int goal = 10}) {
  if (completed > goal) return 100.0;
  return (completed / goal) * 100;
}

/// Returns difficulty level based on rating
Difficulty getDifficultyLevel(int rating) {
  switch (rating) {
    case 1:
      return Difficulty.easy;
    case 2:
      return Difficulty.normal;
    case 3:
      return Difficulty.hard;
    case 4:
      return Difficulty.veryHard;
    case 5:
      return Difficulty.extreme;
    default:
      throw ArgumentError('Invalid rating');
  }
}

/// Returns rating from difficulty level
int getRatingFromDifficulty(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy:
      return 1;
    case Difficulty.normal:
      return 2;
    case Difficulty.hard:
      return 3;
    case Difficulty.veryHard:
      return 4;
    case Difficulty.extreme:
      return 5;
  }
}

/// Formats a Duration to a readable string
String formatDuration(Duration duration) {
  final days = duration.inDays;
  if (days > 0) return '$days day${days > 1 ? 's' : ''}';

  final hours = duration.inHours;
  if (hours > 0) return '$hours hour${hours > 1 ? 's' : ''}';

  final minutes = duration.inMinutes;
  if (minutes > 0) return '$minutes minute${minutes > 1 ? 's' : ''}';

  return 'Just now';
}
