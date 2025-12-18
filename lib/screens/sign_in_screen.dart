import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/providers/auth_provide.dart';
import 'package:project/widgets/my_text_field.dart';
import '../models/AuthState.dart';
import '../widgets/primary_button.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});
//
//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
class SignInScreen extends ConsumerWidget {
  final _phoneCtrl = TextEditingController(text: "+963");
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(AuthNotifierProvider); // for rebuilding ui
    ref.listen<AuthState>(AuthNotifierProvider, (previous, next) {
      // to react when the state changes
      if (next.status == AuthStatus.completed) {
        print("completed");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Navigate to search screen
        Navigator.pushReplacementNamed(context, 'MainScreen');
      } else if (next.status == AuthStatus.error) {
        print("error error from lstener");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Show a pop up with error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'ERROR !!! Try again later',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (next.status == AuthStatus.waiting) {
        print("waiting");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Your account has been saved successfully, wait till the admin review it then sign in',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color(0xFFA26769),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: Duration(days: 1),
          ),
        );
        ref.read(AuthNotifierProvider.notifier).startPolling();
      } else if (next.status == AuthStatus.accepted) {
        ref.read(AuthNotifierProvider.notifier).stopPolling();
        print("accepted");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'The admin accepted your account! you can sign in',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color(0xFF50A2A7),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: Duration(days: 1),
          ),
        );
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgAsset = isDark
        ? 'assets/images/backgrounds/signin_dark_bg.svg'
        : 'assets/images/backgrounds/signin_light_bg.svg';
    //to put the correct bg

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
  resizeToAvoidBottomInset: true,
  body: GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(bgAsset, fit: BoxFit.fill),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05,
              screenHeight * 0.02,
              screenWidth * 0.05,
              screenHeight * 0.02 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100 * screenHeight / 1920),

                Text(
                  "Sign in",
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: screenWidth * 0.15,
                    fontFamily: 'Monoglyceride',
                  ),
                ),

                SizedBox(height: screenHeight * 0.11),

                Text(
                  "Phone Number",
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),

                MyTextField(
                  controller: _phoneCtrl,
                  hintText: "+963-000-000-000",
                  keyboardType: TextInputType.phone,
                  maxLength: 13,
                ),

                SizedBox(height: screenHeight * 0.013),

                Text(
                  "Password",
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),

                MyTextField(
                  controller: _passCtrl,
                  hintText: " * * * * * * * *",
                  obscureText: true,
                ),

                SizedBox(height: screenHeight * 0.02),

                PrimaryButton(
                  label: signIn.status == AuthStatus.loading ? "Loading ..." : "Sign In",
                  onPressed: () {
                    final phone = _phoneCtrl.text.trim();
                    final countryCode = phone.length >= 4 ? phone.substring(0, 4) : phone;
                    final phoneNumber = phone.length > 4 ? phone.substring(4) : "";

                    ref.read(AuthNotifierProvider.notifier).auth(
                      authType: AuthType.sign_in,
                      dataMap: {
                        "country_code": countryCode,
                        "phone_number": phoneNumber,
                        "password": _passCtrl.text,
                      },
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.02),

                Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                    color: cs.secondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: screenHeight * 0.021,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account?\nregister  "),
                      TextSpan(
                        text: "here",
                        style: TextStyle(
                          color: cs.secondary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //well change this to provider things
                            Navigator.pushReplacementNamed(context, "RegisterFirstPage");
                          },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.24),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);

  }
}
