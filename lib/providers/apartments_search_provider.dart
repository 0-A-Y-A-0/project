import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/dio_provider.dart';
import '../../models/apartment.dart';

final apartmentsListProvider = FutureProvider<List<Apartment>>((ref) async {
  final dio = ref.read(dioProvider);
  final res = await dio.get('/apartments'); // endpoint
  final data = (res.data as List);
  return data.map((e) => Apartment.fromJson(e as Map<String, dynamic>)).toList();
});


//this is how we use it in our screen :)
// final apartmentsList = ref.watch(apartmentsListProvider);

// return apartmentsList.when(
//   loading: () => //widget to show loading,
//   error: (e, _) => //widget to show error,
//   data: (list) => ListView.builder(
//     itemCount: list.length,
//     itemBuilder: (_, i) => ListTile(title: Text(list[i].title)),
//   ),
// );