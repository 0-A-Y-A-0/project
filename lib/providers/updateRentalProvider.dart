import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/pastRentalsProvider.dart';
import 'activeRentalsProvider.dart';
import 'dio_provider.dart';

final UpdateRentalProvider =
Provider<Future<void> Function(int rentalId, FormData)>((ref) {
  return (rentalId, formData) async {
    final dio = ref.read(dioProvider);

    try {
      await dio.post(
        '/rental-update-requests/$rentalId/update',
        data: formData,
      );

      ref.invalidate(ActiveRentalsProvider);
      ref.invalidate(PastRentalsProvider);

    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 404) {
        throw Exception(data?['message'] ?? 'Rental not found');
      }

      if (status == 422) {
        throw Exception(
          data?['message'] ?? 'Apartment is already rented for the selected dates',
        );
      }

      if (status == 500) {
        throw Exception('Server exploded. Not your fault. Probably.');
      }

      throw Exception('Unexpected error, try again later.');
    }
  };
});
