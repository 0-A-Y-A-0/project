enum Governorate { Damascus, Aleppo, Homs, Latakia, Tartus, Idlib, Daraa, Swedaa }

class Apartment {
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
  final List<String> photos;

  Apartment({
    required this.governorate,
    required this.city,
    required this.street,
    required this.building_number,
    required this.floor,
    required this.apartment_number,
    required this.number_of_bedrooms,
    required this.number_of_bathrooms,
    required this.area_sq_meters,
    required this.description_en,
    required this.rent_price_per_night,
    this.photos = const [],
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['assets'] ?? json['photos']; // backend might call it assets

    return Apartment(
      governorate: Governorate.values.firstWhere(
        (e) => e.name == (json['governorate'] ?? '').toString(),
        orElse: () => Governorate.Damascus,
      ),
      city: (json['city'] ?? '').toString(),
      street: (json['street'] ?? '').toString(),
      building_number: (json['building_number'] ?? '').toString(),
      floor: (json['floor'] as num?)?.toInt() ?? 0,

      // safer parsing (backend sometimes sends string)
      apartment_number: (json['apartment_number'] as num?)?.toInt()
          ?? int.tryParse((json['apartment_number'] ?? '').toString())
          ?? 0,

      number_of_bedrooms: (json['number_of_bedrooms'] as num?)?.toInt()
          ?? int.tryParse((json['number_of_bedrooms'] ?? '').toString())
          ?? 0,

      number_of_bathrooms: (json['number_of_bathrooms'] as num?)?.toInt()
          ?? int.tryParse((json['number_of_bathrooms'] ?? '').toString())
          ?? 0,

      area_sq_meters: (json['area_sq_meters'] as num?)?.toInt()
          ?? int.tryParse((json['area_sq_meters'] ?? '').toString())
          ?? 0,

      description_en: (json['description_en'] ?? '').toString(),
      rent_price_per_night: (json['rent_price_per_night'] as num?)?.toDouble() ?? 0.0,

      // ✅ read URLs list
      photos: rawPhotos is List
          ? rawPhotos.map((e) => e.toString()).toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'governorate': governorate.name,
        'city': city,
        'street': street,
        'building_number': building_number,
        'floor': floor,
        'apartment_number': apartment_number,
        'number_of_bedrooms': number_of_bedrooms,
        'number_of_bathrooms': number_of_bathrooms,
        'area_sq_meters': area_sq_meters,
        'description_en': description_en,
        'rent_price_per_night': rent_price_per_night,
      };

  String makeAddress() => '$city, $street, $building_number';
}
