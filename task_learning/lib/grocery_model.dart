class Grocery {
  final int? id;
  final String name;
  final String description;

  Grocery({this.id, required this.name, required this.description});

  factory Grocery.fromMap(Map<String, dynamic> json) => new Grocery(
        id: json['id'],
        name: json['name'],
        description: json['description'],
      );

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
