import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/pastRentalsProvider.dart';

import 'activeRentalsProvider.dart';
import 'dio_provider.dart';

final cancelRentalProvider = Provider<Future<void> Function(int)>((ref) {
    final dio = ref.read(dioProvider);

    return (int rentalId) async {
        await dio.put('/user/rentals/$rentalId/cancel');

        ref.invalidate(ActiveRentalsProvider);
        ref.invalidate(PastRentalsProvider);
    };
});


