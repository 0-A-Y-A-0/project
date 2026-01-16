import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Apartment.dart';
import '../models/Governorates.dart';
import 'dio_provider.dart';

class ApartmentDetailsNotifier extends AsyncNotifier<Apartment> {
  @override
  Future<Apartment> build() async {
    // the initial state ... we put anything
    return Apartment(
        id: 0,
        governorateIndex: 0,
        city: "",
        street: "",
        rent_price_per_night: 0);
  }

  Future<void> fetchApartmentDetails(int apartmentId) async {
    state = const AsyncLoading();

    final dio = ref.read(dioProvider);
    final response = await dio.get('/apartments/$apartmentId');

    final data = response.data['apartment'];
    final address = data['address'] ?? {};
    final details = data['details'] ?? {};
    final assets = data['assets'] as List<dynamic>? ?? [];
    final rentals = (data['rentals'] as List<dynamic>?) ?? [];
    final ratings = data['ratings'] as List<dynamic>? ?? [];


    final apartment = Apartment(
      id: data['id'] as int,
      governorateIndex: (address['governorate'] as num).toInt(),
      city: address['city'] as String,
      street: address['street'] as String,
      building_number: address['building_number'].toString(),
      floor: int.tryParse(address['floor'].toString()) ?? 0,
      apartment_number: int.tryParse(address['apartment_number'].toString()) ?? 0,
      number_of_bedrooms: details['number_of_bedrooms'] as int,
      number_of_bathrooms: details['number_of_bathrooms'] as int,
      area_sq_meters: details['area_sq_meters'] as int,
      description_en: details['description_en'] as String,
      rent_price_per_night: double.tryParse(details['rent_price_per_night'].toString()) ?? 0.0,
      photos: assets.map<String>((e) => e['asset_url'] as String).toList(),
      rentals: rentals.map<DateTimeRange>((e) {
        final start = DateTime.parse(e['start_date'] as String);
        final end = DateTime.parse(e['end_date'] as String);
        return DateTimeRange(start: start, end: end);
      }).toList(),
      owner_name: data['owner_name'] as String,
      owner_id: data['user_id'] as int,
      owner_photo_url: data['owner_photo_url'] as String,
      rate: double.tryParse(response.data['rate'].toString()) ?? 0.0,
      comments: ratings.map<Comment>((r) {
        return Comment(
          r['user_name'] as String?,
          r['user_photo_url'] as String?,
          r['comment'] as String?,
          (r['rating'] as num?)?.toDouble(),
        );
      }).toList(),
    );


    state = AsyncData(apartment);
  }
}

final ApartmentDetailsProvider =
AsyncNotifierProvider<ApartmentDetailsNotifier, Apartment>(
    ApartmentDetailsNotifier.new
);

