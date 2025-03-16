class Inventory {
  final String id;
  final String name;

  Inventory({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  Inventory copyWith({String? id, String? name}) {
    return Inventory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
