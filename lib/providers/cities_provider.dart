import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

final CitiesProvider = FutureProvider.family<List<String>, int?>((ref, governorate) async {
  if (governorate == null){
    print("Null gov");
    return [];
  }
  final dio = ref.read(dioProvider);

  print("fetching");
  final response = await dio.get(
    "/governorates/$governorate/cities",
  );

  print("done !");

  // return List<String>.from(response.data);
  return ["first", "second", "third"] ; // just for testing ...
});
