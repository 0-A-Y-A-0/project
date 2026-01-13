import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Apartment.dart';
import 'dio_provider.dart';
import '../models/Governorates.dart';

class FavoritesNotifier extends AsyncNotifier<List<Apartment>> {

  @override
  Future<List<Apartment>> build() async {
    return _fetchFavorites();
  }

  Future<void> toggleFavorite(int apartmentId) async {
    final dio = ref.read(dioProvider);

    print("done.................");

    try {
      await dio.post('/apartments/$apartmentId/favorite');
      state = AsyncData(await _fetchFavorites());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<List<Apartment>> _fetchFavorites() async {
    print("loading ...............");
    final dio = ref.read(dioProvider);

    final response = await dio.get('/favorites');
    final List list = response.data['favorites'];

    if (response.statusCode != 200) {
      throw Exception('Failed to load favorites');
    }

    if (list.isEmpty) {
      return [];
    }

    return list.map<Apartment>((json) {
      final address = json['address'];

      return Apartment(
        id: json['apartment_id'],
        governorate: Governorates.governorates[address['governorate']],
        city: address['city'],
        street: address['street'],
        rent_price_per_night: double.parse(json['price_per_night'].toString()),
        photos: json['asset_url'] == null
            ? []
            : [json['asset_url']],
      );
    }).toList();
  }

}

final FavoritesProvider =
AsyncNotifierProvider<FavoritesNotifier, List<Apartment>>(
  FavoritesNotifier.new,
);
