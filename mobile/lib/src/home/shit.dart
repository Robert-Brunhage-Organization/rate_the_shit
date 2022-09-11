import 'shit_entity.dart';

class Shit {
  Shit({
    required this.name,
    required this.path,
    this.positiveRating = 0,
    this.negativeRating = 0,
    this.skipRating = 0,
    this.id,
  });

  final int? id;
  final String name;
  final String path;
  final int positiveRating;
  final int negativeRating;
  final int skipRating;

  factory Shit.fromEntity(ShitEntity entity) {
    return Shit(
      name: entity.name,
      path: 'assets/images/shit/${entity.name.replaceAll(' ', '_')}.svg',
      positiveRating: entity.positiveRating,
      negativeRating: entity.negativeRating,
      skipRating: entity.skipRating,
      id: entity.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'positiveRating': positiveRating,
      'negativeRating': negativeRating,
      'skipRating': skipRating,
      'name': name,
    };
  }
}
