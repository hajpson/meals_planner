class Product {
  late int id;
  late String name;
  late String shortDescription;
  late String longDescription;

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    shortDescription = map['shortDescription'];
    longDescription = map['longDescription'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
    };
  }
}