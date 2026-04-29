class PetModel {
  final String id;
  final String name;
  final String breed;
  final String age;
  final String description;
  final String image;
  final String price;

  PetModel({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.description,
    required this.image,
    required this.price,
  });

  factory PetModel.fromMap(String id, Map<String, dynamic> data) {
    return PetModel(
      id: id,
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      age: data['age'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: data['price'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'age': age,
      'description': description,
      'image': image,
      'price': price,
      'createdAt': DateTime.now(),
    };
  }
}