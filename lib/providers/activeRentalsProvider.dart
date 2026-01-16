import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/Rental.dart';
import 'dio_provider.dart';

class ActiveRentalsNotifier extends AsyncNotifier<List<Rental>> {
  @override
  Future<List<Rental>> build() async {
    final dio = ref.read(dioProvider);

    final response = await dio.get('/user/my_ongoing_rentals');

    final List data = response.data as List;

    return data.map((item) {
      final apartment = item['apartment'];

      final assets = apartment['assets'] as List?;
      final coverImage =
      (assets != null && assets.isNotEmpty) ? assets.first['url'] : null;

      return Rental(
        id: item['id'],
        userId: item['user_id'],
        start: DateTime.parse(item['rental_start_date']),
        end: DateTime.parse(item['rental_end_date']),
        status: item['status'],
        apartmentId: apartment['id'],
        owner_name: apartment['owner_name'] ?? '',
        cover_image_url: coverImage,
      );
    }).toList();
  }
}

final ActiveRentalsProvider =
AsyncNotifierProvider<ActiveRentalsNotifier, List<Rental>>(
  ActiveRentalsNotifier.new,
);
