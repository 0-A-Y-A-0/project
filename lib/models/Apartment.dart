import 'package:project/models/Governorates.dart';

class Apartment {
  final int id;
  final String governorate;
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
  final List<String> photos;

  Apartment({
    required this.id,
    required this.governorate,
    required this.city,
    required this.street,
    this.building_number = '',
    this.floor = 0,
    this.apartment_number = 0,
    this.number_of_bedrooms = 0,
    this.number_of_bathrooms = 0,
    this.area_sq_meters = 0,
    this.description_en = '',
    required this.rent_price_per_night,
    this.photos = const [],
  });

  // factory Apartment.fromJson(Map<String, dynamic> json) {
  //   final rawPhotos = json['photos'] ?? json['assets'];
  //
  //   return Apartment(
  //     id: (json['apartment_id'] as num?)?.toInt()
  //         ?? int.tryParse(json['apartment_id']?.toString() ?? '')
  //         ?? 0,
  //
  //     governorate: (json['governorate'] as num?)?.toInt()
  //         ?? int.tryParse(json['governorate']?.toString() ?? '')
  //         ?? 0,
  //
  //     city: json['city']?.toString() ?? '',
  //     street: json['street']?.toString() ?? '',
  //     building_number: json['building_number']?.toString() ?? '',
  //
  //     floor: (json['floor'] as num?)?.toInt()
  //         ?? int.tryParse(json['floor']?.toString() ?? '')
  //         ?? 0,
  //
  //     apartment_number: (json['apartment_number'] as num?)?.toInt()
  //         ?? int.tryParse(json['apartment_number']?.toString() ?? '')
  //         ?? 0,
  //
  //     number_of_bedrooms: (json['number_of_bedrooms'] as num?)?.toInt()
  //         ?? int.tryParse(json['number_of_bedrooms']?.toString() ?? '')
  //         ?? 0,
  //
  //     number_of_bathrooms: (json['number_of_bathrooms'] as num?)?.toInt()
  //         ?? int.tryParse(json['number_of_bathrooms']?.toString() ?? '')
  //         ?? 0,
  //
  //     area_sq_meters: (json['area_sq_meters'] as num?)?.toInt()
  //         ?? int.tryParse(json['area_sq_meters']?.toString() ?? '')
  //         ?? 0,
  //
  //     description_en: json['description_en']?.toString() ?? '',
  //
  //     rent_price_per_night: (json['rent_price_per_night'] as num?)?.toDouble()
  //         ?? double.tryParse(json['rent_price_per_night']?.toString() ?? '')
  //         ?? 0.0,
  //
  //     photos: rawPhotos is List
  //         ? rawPhotos.map((e) => e.toString()).toList()
  //         : const [],
  //   );
  // }


  String makeAddress() => '$governorate, $city, $street';
}
