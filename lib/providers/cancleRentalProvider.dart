import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/pastRentalsProvider.dart';

import 'activeRentalsProvider.dart';
import 'dio_provider.dart';

final CancelRentalProvider = FutureProvider.family<void, int>((ref, rentalId) async {
    final dio = ref.read(dioProvider);

    await dio.put('/user/rentals/$rentalId/cancel');

    // refresh
    ref.invalidate(ActiveRentalsProvider);
    ref.invalidate(PastRentalsProvider);
});
