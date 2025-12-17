class Apartment {//all data can be modified 
  final String id;
  final String city;
  final int rooms;
  final double pricePerDay;

  const Apartment({
    required this.id,
    required this.city,
    required this.rooms,
    required this.pricePerDay,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      //depends on what backend sends/what we need but we need the syntax :)
      id: json['id'].toString(),
      city: (json['city'] ?? '').toString(),
      rooms: (json['rooms'] ?? 0) as int,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
    );
  }
}
