import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/User.dart';
import 'dio_provider.dart';

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null; // the user is null
  }

  // to set the user from the Auth notifier
  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  // for later
  Future<void> updateUser({
    String? firstName,
    String? lastName,
    String? pfp,
    String? bio,})
  async {
    if (state == null) return;

    final dio = ref.read(dioProvider);

    // we edit this later -----------------------------------
    final response = await dio.post(
      '/user/update',
      data: {
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    if (response.statusCode == 200) {
      //here we take the new data from the response

      // state = User(
      //     first_name: firstName!,
      //     last_name: lastName!,
      //     birth_date: null,
      //     photo_url: photo_url,
      //     doc_url: doc_url,
      //     phone: phone
      // );
    }
  }
}

final UserProvider = NotifierProvider<UserNotifier, User?>((){
  return UserNotifier();
});

