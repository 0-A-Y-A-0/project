import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/AuthState.dart';
import 'package:dio/dio.dart';
import 'package:project/models/User.dart';

enum AuthType { sign_in, register}

class AuthNotifier extends Notifier<AuthState>{

  @override
  AuthState build() {
    return AuthState(status: AuthStatus.initial) ;
  }

  Future<void> auth({required AuthType authType, required Map <String, dynamic> dataMap}) async {
    state = AuthState(status: AuthStatus.loading) ;

    try {
      // this is where we request
      final dio = Dio();
      final response = await dio.post(
        // sign in or register url
        authType == AuthType.sign_in
        ? 'https://signin_url'
        : 'https://register_url',
        // the data as a map { name : "fas3oon", phone: 000, ...}
        data: dataMap,
      );

      if (response.statusCode == 200) {
        if (authType == AuthType.sign_in){
          // if it succeeded && sign in, store the info
          state = AuthState(status: AuthStatus.completed, user: User(
            phone: response.data['phone'],
            password: response.data['password'],
            token: response.data['token'],
          ), error: "no error!");
        }else{
          // if it succeeded && sign in, store the info
          state = AuthState(status: AuthStatus.waiting, error: "wait for the admin to accept your account");
        }
      } else {
        // if the response status is not 200 => error
        state = AuthState(status: AuthStatus.error, error: "there's an error bro");
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.error, error: "there's an error bro");
    }
  }


}

// this is the provider 💀
final AuthNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
        () { return AuthNotifier(); }
);