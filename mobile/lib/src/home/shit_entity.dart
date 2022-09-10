class ShitEntity {
  final int id;
  final int positiveRating;
  final int negativeRating;
  final int skipRating;
  final String name;

  ShitEntity(
    this.id,
    this.positiveRating,
    this.negativeRating,
    this.skipRating,
    this.name,
  );

  static ShitEntity fromMap(Map<String, dynamic> map) {
    return ShitEntity(
      map['id'],
      map['positiveRating'],
      map['negativeRating'],
      map['skipRating'],
      map['name'],
    );
  }
}
