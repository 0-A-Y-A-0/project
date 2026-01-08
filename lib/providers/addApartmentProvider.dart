import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/user_provider.dart';

import 'apartmentsProvider.dart';
import 'dio_provider.dart';

final AddApartmentProvider = FutureProvider.family<void, FormData>((ref, formData) async {

  // taking the user token
  final user = ref.read(UserProvider);
  final token = user?.token;
  print(user?.token);

  try{
    final dio = ref.read(dioProvider);

    print(formData.fields);
    print(formData.files.map((e) => e.key).toList());

    print("to the back ---------------------");
    final response = await dio.post(
      '/apartments/create',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer $token'
        },
      ),
    );
    print("done sending-----------------------------------");

    // 422 validation
    // 409 address
    if(response.statusCode == 409){
      throw Exception('Address already exists');
    }else if(response.statusCode == 422){
      throw Exception("Validation error");
    }

    ref.invalidate(ApartmentsProvider);
  }catch (e){
    print(e.toString());
  }
});

