
import 'package:project/models/User.dart';

enum AuthStatus { initial, loading, waiting, completed, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({required this.status, this.user, this.error,});

}
