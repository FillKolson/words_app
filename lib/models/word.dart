import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word extends HiveObject {
  @HiveField(0)
  String english;

  @HiveField(1)
  String ukrainian;

  @HiveField(2)
  int difficulty; // 1–5

  @HiveField(3)
  DateTime nextReview;

  @HiveField(4)
  bool isKnown;

  Word({
    required this.english,
    required this.ukrainian,
    this.difficulty = 3,
    DateTime? nextReview,
    this.isKnown = false,
  }) : nextReview = nextReview ?? DateTime.now();

  void rate(int rating) {
    difficulty = rating;
    if (rating >= 4) {
      isKnown = true;
    } else {
      const days = [1, 2, 4, 7, 14];
      nextReview = DateTime.now().add(Duration(days: days[rating - 1]));
    }
    // Only save if this object is in a box
    if (key != null) {
      save();
    }
  }
}