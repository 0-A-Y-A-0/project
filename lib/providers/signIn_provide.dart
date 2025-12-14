import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/SignInState.dart';
import 'package:dio/dio.dart';

class SignInNotifier extends Notifier<SignInState>{

  @override
  SignInState build() {
    return SignInState(status: SignInStatus.initial) ;
  }

  Future<void> signIn({required String phone, required String password}) async {
    state = SignInState(status: SignInStatus.loading) ;

    try {
      // this is where we request
      final dio = Dio();
      final response = await dio.post(
        'https://signin_url',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // if it succeeded, store the info
        state = SignInState(status: SignInStatus.success, user: User(
          phone: response.data['phone'],
          password: response.data['password'],
          token: response.data['token'],
        ), error: "no error!");
      } else {
        // if the response status is not 200 => error
        state = SignInState(status: SignInStatus.error, error: "there's an error bro");
      }
    } catch (e) {
      state = SignInState(status: SignInStatus.error, error: "there's an error bro");
    }
  }


}

// this is the provider 💀
final SignInNotifierProvider = NotifierProvider<SignInNotifier, SignInState>(
        () { return SignInNotifier(); }
);