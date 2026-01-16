import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

final AddRentalProvider = Provider<Future<void> Function(FormData)>((ref) {
  return (formData) async {

    // if(response.statusCode == 422){
    //   throw Exception('Apartment is already rented for the selected dates');
    // }else if(response.statusCode == 409){
    //   throw Exception("You already have an active rental request for these dates");
    // }

    final apartmentId = formData.fields
        .firstWhere((e) => e.key == 'apartment_id')
        .value;

    print ("APARTMENT ID: $apartmentId");

    final dio = ref.read(dioProvider);

    try {
      await dio.post(
        '/apartments/$apartmentId/rentals',
        data: formData,
      );
      print("DONE FROM PROVIDER!!!!!!!!!!!!!!!!!!!");

    }on DioException catch (e) {
      // to make custom error messages
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 422) {
        throw Exception(
          data?['message'] ?? 'Selected dates are not available',
        );
      }

      if (status == 409) {
        throw Exception(
          data?['message'] ?? 'You already requested this rental',
        );
      }

      if (status == 500) {
        throw Exception('Server exploded. Not your fault. Probably.');
      }

      throw Exception('Unexpected error, try again later.');

    }

  };
});

