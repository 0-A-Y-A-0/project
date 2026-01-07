import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/user_provider.dart';

import 'apartmentsProvider.dart';
import 'dio_provider.dart';

final AddApartmentProvider = FutureProvider.family<void, FormData>((ref, formData) async {

  // taking the user token
  final user = ref.read(UserProvider);
  final token = user?.token;

  final dio = ref.read(dioProvider);

  print(formData.fields);
  print(formData.files.map((e) => e.key).toList());

  print("to the back ---------------------");
  await dio.post(
    '/apartments/create',
    data: formData,
    options: Options(
      headers: {
        'Authorization': 'Bearer $token'
      },
    ),
  );
  print("done-----------------------------------");

  ref.invalidate(ApartmentsProvider);
});

