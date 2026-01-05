
import 'package:project/models/User.dart';

enum AuthStatus { initial, loading, waiting, accepted, completed, error }

class AuthState {
  final AuthStatus status;
  final String? error;

  const AuthState({required this.status, this.error,});

}
