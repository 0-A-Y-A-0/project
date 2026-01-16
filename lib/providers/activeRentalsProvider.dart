import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/Rental.dart';
import 'dio_provider.dart';

class ActiveRentalsNotifier extends AsyncNotifier<List<Rental>> {
  @override
  Future<List<Rental>> build() async {
    final dio = ref.read(dioProvider);

    print ("TO THE BACK ----------------------- active rentals ");

    final response = await dio.get('/user/my_ongoing_rentals');

    final List data = response.data as List;

    print ("FROM THE BACK RESPONSE ----------------------- ${data.length} ");

    return data.map((item) {
      final apartment = item['apartment'];
      final assets = apartment['assets'] as List?;
      final coverImage =
      (assets != null && assets.isNotEmpty) ? assets.first['asset_url'] : null;

      final update = item['pending_update_request'];

      // print(item['id']);
      // print(item['user_id']);
      // print(DateTime.parse(item['rental_start_date']));
      // print(DateTime.parse(item['rental_end_date']));
      // print(item['status']);
      // print(apartment['id']);
      // print(apartment['owner_name'] ?? '');
      // print(coverImage);
      //
      // if (update != null) {
      //   print(DateTime.parse(update['requested_start_date']));
      //   print(DateTime.parse(update['requested_end_date']));
      // }

      return Rental(
        id: item['id'],
        userId: item['user_id'],
        start: DateTime.parse(item['rental_start_date']),
        end: DateTime.parse(item['rental_end_date']),
        status: item['status'],
        apartmentId: apartment['id'],
        owner_name: apartment['owner_name'] ?? '',
        cover_image_url: coverImage,
        updateRequest: update != null ? UpdateRequest(
            start: DateTime.parse(update['requested_start_date']),
            end: DateTime.parse(update['requested_end_date']),
          id: update['id']
        ) : null
      );
    }).toList();
  }
}

final ActiveRentalsProvider =
AsyncNotifierProvider<ActiveRentalsNotifier, List<Rental>>(
  ActiveRentalsNotifier.new,
);
