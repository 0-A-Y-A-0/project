import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/my_apartments_screen.dart';
import '../models/Apartment.dart';
import 'dio_provider.dart';
import '../models/Governorates.dart';

class MyAptNotifier extends AsyncNotifier<List<Apartment>> {

  @override
  Future<List<Apartment>> build() async {
    return _fetchMy();
  }

  Future<List<Apartment>> _fetchMy() async {
    print("loading ...............");
    final dio = ref.read(dioProvider);

    final response = await dio.get('/apartments/');
    final List list = response.data;

    if (response.statusCode != 200) {
      throw Exception('Failed to load favorites');
    }

    if (list.isEmpty) {
      return [];
    }

    return list.map<Apartment>((json) {
      final address = json['address'];
      final details = json['details'];

      return Apartment(
        id: json['id'],
        governorateIndex: (address['governorate'] as num).toInt(),
        city: address['city'],
        street: address['street'],
        rent_price_per_night: double.parse(details['rent_price_per_night'].toString()),
        photos: (json['assets'] != null && (json['assets'] as List).isNotEmpty)
            ? [(json['assets'][0]['asset_url'] as String)]
            : [],
      );
    }).toList();
  }

}

final MyApartmentsProvider =
AsyncNotifierProvider<MyAptNotifier, List<Apartment>>(
  MyAptNotifier.new,
);
