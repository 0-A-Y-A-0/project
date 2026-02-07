import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/generated/l10n/app_localizations.dart';
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
    final AppLocalizations t = AppLocalizations.of(context)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // to react when the state changes
      if (signIn.status == AuthStatus.completed) {
        print("completed");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Navigate to search screen
        Navigator.pushReplacementNamed(context, 'MainScreen');
      } else if (signIn.status == AuthStatus.error) {
        print("error error from lstener");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Show a pop up with error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.auth_errorTryLater,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: Duration(seconds: 5),
          ),
        );
      } else if (signIn.status == AuthStatus.waiting) {
        print("waiting");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.auth_waitingReview,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color(0xFFA26769),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: Duration(seconds: 5),
          ),
        );
      } else if (signIn.status == AuthStatus.accepted) {
        ref.read(AuthNotifierProvider.notifier).stopPolling();
        print("accepted");
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.auth_adminAccepted,
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color(0xFF50A2A7),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: Duration(seconds: 5),
          ),
        );
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;


    final bgAsset = switch ((isRtl, isDark)) {
      (false, false) => 'assets/images/backgrounds/signin_light_bg.svg',
      (false, true) => 'assets/images/backgrounds/signin_dark_bg.svg',
      (true, false) => 'assets/images/backgrounds/rtl_signin_light_bg.svg',
      (true, true) => 'assets/images/backgrounds/rtl_signin_dark_bg.svg',
    };
    //to put the correct bg

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
  resizeToAvoidBottomInset: false, // true
  body: GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Stack(
      children: [
        SizedBox.expand(
          child: SvgPicture.asset(bgAsset, fit: BoxFit.fill),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05,
              screenHeight * 0.02,
              screenWidth * 0.05,
              screenHeight * 0.02 , // + MediaQuery.of(context).viewInsets.bottom
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100 * screenHeight / 1920),

                Text(
                  t.signin_button,
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: isRtl ? screenWidth * 0.085 : screenWidth * 0.15,
                    fontFamily: 'Monoglyceride',
                  ),
                ),

                SizedBox(height: isRtl ? screenHeight * 0.11 : screenHeight * 0.075),

                Text(
                  t.phoneLabel,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),

                Directionality(
                  textDirection: TextDirection.ltr,
                  child: MyTextField(
                    controller: _phoneCtrl,
                    hintText: "+963-000-000-000",
                    keyboardType: TextInputType.phone,
                    maxLength: 13,
                  ),
                ),

                SizedBox(height: screenHeight * 0.013),

                Text(
                  t.passwordLabel,
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
                  label: signIn.status == AuthStatus.loading ? t.signin_loading : t.signin_button,
                  onPressed: signIn.status == AuthStatus.loading ? null
                    : () {
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
                  t.signin_forgotPassword,
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
                      TextSpan(text: t.signin_noAccount),
                      TextSpan(
                        text: t.here,
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
