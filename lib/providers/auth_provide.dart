import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/AuthState.dart';
import 'package:dio/dio.dart';
import 'package:project/models/User.dart';
import 'package:project/providers/activeRentalsProvider.dart';
import 'package:project/providers/apartmentsProvider.dart';
import 'package:project/providers/dio_provider.dart';
import 'package:project/providers/favorites_provider.dart';
import 'package:project/providers/pastRentalsProvider.dart';
import 'package:project/providers/requestsProvider.dart';
import 'package:project/providers/user_provider.dart';

import '../services/push_notification.dart';

enum AuthType { sign_in, register }

class AuthNotifier extends Notifier<AuthState> {
  Timer? _pollingTimer;
  @override
  AuthState build() {
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });
    return AuthState(status: AuthStatus.initial);
  }

  Future<void> auth({
    required AuthType authType,
    required Map<String, dynamic> dataMap,
  }) async {
    state = AuthState(status: AuthStatus.loading);

    try {
      print("is loading");
      // this is where we request
      final dio = ref.read(dioProvider); //used dio provider

      final response = await dio.post(
        // sign in or register url
        authType == AuthType.sign_in ? '/user/login' : '/user/register',
        data: FormData.fromMap(dataMap),
      );

      if (response.statusCode == 200) {
        // if it succeeded && sign in, store the info
        final userData = response.data['user'];
        state = AuthState(
          status: AuthStatus.completed,
          error: "no error!",
        );

        print ("USER ID : ${userData['id']}");

        // creating the user in the user provider
        ref.read(UserProvider.notifier).setUser(
          User(
            phone: userData['phone']['full_phone_str'],
            token: response.data['token'],
            first_name: userData['first_name'],
            last_name: userData['last_name'],
            birth_date: DateTime.parse(userData['birth_date']),
            photo_url: userData['legal_photo_url'],
            doc_url: userData['legal_doc_url'],
            id:  userData['id']
          ),
        );

        print(userData['legal_photo_url']);


        // sending the token to the back
        final fcmToken = await PushNotificationsService.getDeviceToken();
        if (fcmToken != null) {
          await PushNotificationsService.sendTokenToServer(fcmToken, authToken: response.data['token']);
        }

        // refreshing all the providers
        ref.invalidate(ActiveRentalsProvider);
        ref.invalidate(ApartmentsProvider);
        ref.invalidate(FavoritesProvider);
        ref.invalidate(PastRentalsProvider);
        ref.invalidate(RequestsProvider);

      } else if (response.statusCode == 201) {
        print('register completed');
        // if it succeeded && register, is waiting and store the user
        final userData = response.data['user'];
        state = AuthState(
          status: AuthStatus.waiting,
          error: "wait for the admin to accept your account",
        );

        // creating the user in the user provider
        ref.read(UserProvider.notifier).setUser(
          User(
            phone: userData['phone']['full_phone_str'],
            first_name: userData['first_name'],
            last_name: userData['last_name'],
            birth_date: DateTime.parse(userData['birth_date']),
            photo_url: userData['legal_photo_url'],
            doc_url: userData['legal_doc_url'],
          ),
        );

        startPolling();
      } else {
        print(response.statusCode);
        // if the response status is not 200 => error
        state = AuthState(
          status: AuthStatus.error,
          error: "there's an error bro",
        );
      }
    } on DioException catch (e) {
      print("catch Dio error");
      print("STATUS: ${e.response?.statusCode}");
      print(
        "DATA: ${e.response?.data}",
      ); 
      state = AuthState(status: AuthStatus.error, error: "validation error");
    } catch (e) {
      print("catch error");
      print(e.toString());
      state = AuthState(status: AuthStatus.error, error: "unknown error");
    }
  }

  void startPolling() {
    _pollingTimer?.cancel();
    print("started polling");

    final user = ref.read(UserProvider);
    String? phone = user?.phone;
    print("phone: $phone");

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final user = ref.watch(UserProvider);
        String? phone = user?.phone;
        print("polling");
        print("phone: $phone");

        final dio = ref.read(dioProvider);
        final response = await dio.get(
          '/user/check-approve',
          data: {'full_phone_str': phone},
        );

        if (response.statusCode == 200) {
          print("polling finished");
          _pollingTimer?.cancel();

          state = AuthState(status: AuthStatus.accepted);
        } else {
          print("request error");
        }
      } on DioException catch (e) {
        print("catch polling Dio error");
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      } catch (_) {
        print("polling error");
        // nothing
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<void> logout() async {

    _pollingTimer?.cancel();

    try {
      final dio = ref.read(dioProvider);

      final response = await dio.post('/user/logout',);

      // we change the status => jump to the sign in screen
      state = AuthState(status: AuthStatus.initial);
      ref.read(UserProvider.notifier).clearUser();

      print ("you're out");

    } catch (e) {
      print("logout unknown error");
    }
  }

}

// this is the provider 💀
final AuthNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
