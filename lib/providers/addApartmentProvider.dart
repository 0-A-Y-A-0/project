import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/user_provider.dart';

import 'apartmentsProvider.dart';
import 'dio_provider.dart';

final AddApartmentProvider = Provider<Future<void> Function(FormData)>((ref) {
  return (formData) async {

    final dio = ref.read(dioProvider);

    print(formData.fields);
    print(formData.files.map((e) => e.key).toList());

    print("to the back ---------------------");

    try{
      final response = await dio.post(
        '/apartments/create',
        data: formData,);
      print("done sending-----------------------------------");

      // 422 validation
      // 409 address
      // if(response.statusCode == 409){
      //   throw Exception('Address already exists');
      // }else if(response.statusCode == 422){
      //   throw Exception("Validation error");
      // }

      ref.invalidate(ApartmentsProvider);
    }on DioException catch (e) {
      // to make custom error messages

      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == 422) {
        throw Exception(
          data?['message'] ?? 'Validation error',
        );
      }

      if (status == 409) {
        throw Exception(
          data?['message'] ?? 'Address already exists',
        );
      }

      if (status == 500) {
        throw Exception('Server exploded. Not your fault. Probably.');
      }

      throw Exception('Unexpected error, try again later.');
    }
  };

});

