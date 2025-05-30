class CarAd {
  int? id;
  String brand;
  String model;
  String year;
  String engineCapacity;
  String mileage;
  String price;
  String description;
  String imagePath;
  bool isFavorite;

  CarAd({
    this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.engineCapacity,
    required this.mileage,
    required this.price,
    required this.description,
    required this.imagePath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'engineCapacity': engineCapacity,
      'mileage': mileage,
      'price': price,
      'description': description,
      'imagePath': imagePath,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory CarAd.fromMap(Map<String, dynamic> map) {
    return CarAd(
      id: map['id'],
      brand: map['brand'],
      model: map['model'],
      year: map['year'],
      engineCapacity: map['engineCapacity'],
      mileage: map['mileage'],
      price: map['price'],
      description: map['description'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
