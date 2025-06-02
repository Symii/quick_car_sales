class CarImage {
  final int? id;
  final int carAdId;
  final String imagePath;

  CarImage({
    this.id,
    required this.carAdId,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carAdId': carAdId,
      'imagePath': imagePath,
    };
  }

  factory CarImage.fromMap(Map<String, dynamic> map) {
    return CarImage(
      id: map['id'],
      carAdId: map['carAdId'],
      imagePath: map['imagePath'],
    );
  }
}