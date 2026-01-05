import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/dio_provider.dart';
import 'package:project/models/Apartment.dart';
import 'package:dio/dio.dart';

// this should be async notifier ... easier
// the whole class should be edited
class ApartmentsNotifier extends Notifier<AsyncValue<List<Apartment>>> {
  @override
  AsyncValue<List<Apartment>> build() {
    // load once when provider is first created
    Future.microtask(loadApartments);
    return const AsyncLoading();
  }

  Future<List<Apartment>> _getApartmentsList() async {
    final dio = ref.read(dioProvider);
    final res = await dio.get('/apartments');

    final raw = res.data;

    // backend can return [ ... ] OR { data: [ ... ] }
    final List list =
        (raw is Map && raw['data'] is List) ? raw['data'] as List : raw as List;

    // return list
    //     .map((e) => Apartment.fromJson(Map<String, dynamic>.from(e)))
    //     .toList();

    return [];
  }

  Future<void> loadApartments() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await _getApartmentsList();
    });
  }

  Future<void> refresh() => loadApartments();

  Future<void> createApartment(FormData payload) async {
    final oldList = state.asData?.value;

    // keep current list visible while sending request
    if (oldList != null) {
      state = AsyncData(oldList);
    }

    final result = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);

      // create
      await dio.post('/apartments/create', data: payload);

      // then reload list
      return await _getApartmentsList();
    });

    // if create failed, keep old list visible
    if (result.hasError && oldList != null) {
      state = AsyncData(oldList);
      return;
    }

    state = result;
  }
}

final apartmentsProvider =
NotifierProvider<ApartmentsNotifier, AsyncValue<List<Apartment>>>(//very lovely provider gives built in error loading and success
  ApartmentsNotifier.new,
);





// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:project/providers/dio_provider.dart';
// import '../../models/apartment.dart';

// final apartmentsListProvider = FutureProvider<List<Apartment>>((ref) async {
//   final dio = ref.read(dioProvider);
//   final res = await dio.get('/apartments'); // endpoint
//   final data = (res.data as List);
//   return data.map((e) => Apartment.fromJson(e as Map<String, dynamic>)).toList();
// });

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