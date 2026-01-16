import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/pastRentalsProvider.dart';

import 'activeRentalsProvider.dart';
import 'dio_provider.dart';

final cancelUpdateProvider = Provider<Future<void> Function(int)>((ref) {
  final dio = ref.read(dioProvider);

  return (int updateRequestID) async {
    await dio.put('/rental-update-requests/$updateRequestID/cancel');

    ref.invalidate(ActiveRentalsProvider);
    ref.invalidate(PastRentalsProvider);
  };
});


