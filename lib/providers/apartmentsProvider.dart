import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/Governorates.dart';
import '../models/Apartment.dart';
import 'dio_provider.dart';

class ApartmentsNotifier extends AsyncNotifier<List<Apartment>> {
  @override
  Future<List<Apartment>> build() async {
    final dio = ref.read(dioProvider);

    final response = await dio.get('/apartments/filter');

    final List list = response.data;

    return list.map<Apartment>((json) {
      final address = json['address'] ?? {};

      return Apartment(
        id: json['apartment_id'],
        governorate: Governorates.governorates[address['governorate']],
        city: address['city'],
        street: address['street'],
        rent_price_per_night: double.parse(json['price_per_night'].toString()),
        photos: json['assets'] == null ? [] : [json['assets']],
      );
    }).toList();
    // return fetchApartments(dataMap: {});
  }

  Future<void> fetchApartments({
    required Map<String, dynamic> dataMap,
  }) async {
    state = const AsyncLoading();
    print("loading..............");

    final dio = ref.read(dioProvider);

    final response = await dio.get(
      '/apartments/filter',
      queryParameters: dataMap,
    );

    final List list = response.data;

    state = AsyncData(
      list.map<Apartment>((json) {
        final address = json['address'];

        return Apartment(
          id: json['apartment_id'],
          governorate: Governorates.governorates[address['governorate']],
          city: address['city'],
          street: address['street'],
          rent_price_per_night:
          double.parse(json['price_per_night'].toString()),
          photos: json['assets'] == null
              ? []
              : (json['assets'] is List
              ? List<String>.from(json['assets'])
              : [json['assets'].toString()]),
        );
      }).toList(),
    );

    print("done.................");
  }



}

final ApartmentsProvider =
AsyncNotifierProvider<ApartmentsNotifier, List<Apartment>>(
  ApartmentsNotifier.new,
);
