import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/requestsProvider.dart';
import 'dio_provider.dart';

final acceptRequestProvider = Provider<Future<void> Function(int, bool)>((ref) {
  final dio = ref.read(dioProvider);

  return (int rentalId, bool isEdit) async {
    // normal -> rentalId is the rental id
    // isEdit -> rentalId is the edit request id

    if (isEdit) {
      // approve the edit request
      await dio.put('/rental-update-requests/$rentalId/accept');
    } else {
      // approve normal requests
      await dio.put('/user/rentals/$rentalId/approve');
    }

    ref.invalidate(RequestsProvider);
  };
});


