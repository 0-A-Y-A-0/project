import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

final AddRentalProvider = FutureProvider.family<void, FormData>((ref, formData) async {

  try{
    final apartmentId = formData.fields
        .firstWhere((e) => e.key == 'apartment_id')
        .value;

    print ("APARTMENT ID: $apartmentId");

    final dio = ref.read(dioProvider);

    final response = await dio.post(
      '/apartments/$apartmentId/rentals',
      data: formData,
    );

    print("DONE FROM PROVIDER!!!!!!!!!!!!!!!!!!!");

    // if(response.statusCode == 422){
    //   throw Exception('Apartment is already rented for the selected dates');
    // }else if(response.statusCode == 409){
    //   throw Exception("You already have an active rental request for these dates");
    // }

  }on DioException catch (e) {
    final status = e.response?.statusCode;
    final message = e.response?.data['message'] ?? 'Request failed';

    if (status == 422 || status == 409) {
      throw Exception(message);
    }

    throw Exception('Unexpected error');
  }
});

