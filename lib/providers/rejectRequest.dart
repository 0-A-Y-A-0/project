import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/requestsProvider.dart';
import 'dio_provider.dart';

final rejectRequestProvider = Provider<Future<void> Function(int, bool)>((ref) {
  final dio = ref.read(dioProvider);

  return (int rentalId, bool isEdit) async {
    // normal -> rentalId is the rental id
    // isEdit -> rentalId is the edit request id

    if (isEdit) {
      // reject the edit request
      await dio.put('/rental-update-requests/$rentalId/reject');
    } else {
      // reject normal requests
      await dio.put('/user/rentals/$rentalId/reject');
    }

    ref.invalidate(RequestsProvider);
  };
});


