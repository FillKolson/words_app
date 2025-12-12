import 'package:hive/hive.dart';

part 'word.g.dart'; // Генеруватиметься build_runner

@HiveType(typeId: 0)
class Word extends HiveObject {
  @HiveField(0)
  String english;

  @HiveField(1)
  String ukrainian;

  @HiveField(2)
  int difficulty; // 1-5, як добре пам'ятаєш

  @HiveField(3)
  DateTime nextReview;

  @HiveField(4)
  bool isKnown; // чи вивчене

  Word({
    required this.english,
    required this.ukrainian,
    this.difficulty = 3,
    required this.nextReview,
    this.isKnown = false,
  });

  void updateDifficulty(int newDifficulty) {
    difficulty = newDifficulty;
    if (newDifficulty == 5) {
      isKnown = true;
    } else {
      // Інтервальний розклад: 1 день, 3 дні, 7 днів, 14 днів, 30 днів
      int days = [1, 3, 7, 14, 30][difficulty - 1];
      nextReview = DateTime.now().add(Duration(days: days));
    }
    save();
  }
}