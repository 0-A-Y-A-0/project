
enum SignInStatus { initial, loading, success, error }

class User {
  String? phone;
  String? password ;
  String? token;

  User({required this.phone, required this.password, required this.token});
}

class SignInState {
  final SignInStatus status;
  final User? user;
  final String? error;

  const SignInState({required this.status, this.user, this.error,});

}
