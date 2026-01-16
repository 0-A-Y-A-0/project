import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:project/providers/activeRentalsProvider.dart';
import 'package:project/providers/pastRentalsProvider.dart';
import 'package:project/services/providerContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_notification.dart';

@pragma('vm:entry-point')
class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  // preparing ... idk
  static Future<void> init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();

    messaging.onTokenRefresh.listen((newToken) async {
      log("FCM Token Refreshed: $newToken");
      await sendTokenToServer(newToken);
    });
  }

  // getting the phone token
  static Future<String?> getDeviceToken() async {
    try {
      String? token = await messaging.getToken();
      log("My FCM Token: $token");
      return token;
    } catch (e) {
      log("Error getting device token: $e");
      return null;
    }
  }

  // sending the FCM token to the backend
  static Future<void> sendTokenToServer(String fcm_token, {String? authToken}) async {
    try {
      String? finalToken = authToken;
      if (finalToken == null) {
      final prefs = await SharedPreferences.getInstance();
      finalToken = prefs.getString('auth_token');
    }

    if (finalToken == null) {
      log("No auth token found, cannot update FCM on server.");
      return;
    }
      final dio = Dio();
      dio.options.headers["Authorization"] = "Bearer $finalToken";
      dio.options.headers["Accept"] = "application/json";
      
      final response = await dio.post(
        'http://10.0.2.2:8000/api/user/fcm-token',
        data: {'fcm_token': fcm_token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("FCM Token updated successfully on server.");
      }
    } catch (e) {
      log("Failed to send FCM token to server: $e");
    }
  }

  // handling the notifications in the background
  @pragma('vm:entry-point') // important
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Background Message: ${message.notification?.title}");
  }

  // handling the notifications when the app is  open
  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Message: ${message.notification?.title}"); // debugging
      LocalNotificationService.showBasicNotification(message); // to show the notification

      // to refresh the providers
      providerContainer.invalidate(ActiveRentalsProvider);
      providerContainer.invalidate(PastRentalsProvider);
    });
  }
}