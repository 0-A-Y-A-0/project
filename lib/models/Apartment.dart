enum Governorate { Damascus, Aleppo, Homs, Latakia, Tartus, Idlib, Daraa, Swedaa }
class Apartment {//all data can be modified
  final Governorate governorate;
  final String city;
  final String street;
  final String building_number;
  final int floor;
  final int apartment_number;
  final int number_of_bedrooms;
  final int number_of_bathrooms;
  final int area_sq_meters;
  final String description_en;
  final double rent_price_per_night;

  const Apartment({required this.governorate, required this.city, required this.street, required this.building_number, required this.floor, required this.apartment_number, required this.number_of_bedrooms, required this.number_of_bathrooms, required this.area_sq_meters, required this.description_en, required this.rent_price_per_night, 
  
});

  factory Apartment.fromJson(Map<String, dynamic> json) {
  return Apartment(
    governorate: Governorate.values.firstWhere(
      (e) => e.name == (json['governorate'] ?? '').toString(),
      orElse: () => Governorate.Damascus,
    ),
    city: (json['city'] ?? '').toString(),
    street: (json['street'] ?? '').toString(),
    building_number: (json['building_number'] ?? '').toString(),
    floor: (json['floor'] ?? 0) as int,
    apartment_number: (json['apartment_number'] ?? 0) as int,
    number_of_bedrooms: (json['number_of_bedrooms'] ?? 0) as int,
    number_of_bathrooms: (json['number_of_bathrooms'] ?? 0) as int,
    area_sq_meters: (json['area_sq_meters'] ?? 0) as int,
    description_en: (json['description_en'] ?? '').toString(),
    rent_price_per_night: (json['rent_price_per_night'] as num?)?.toDouble() ?? 0.0,
  );
}
}
