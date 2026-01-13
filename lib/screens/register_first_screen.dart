import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/screens/register_second_screen.dart';
import 'package:project/widgets/my_text_field.dart';

// import '../providers/auth_provide.dart';
import '../widgets/primary_button.dart';

class RegisterFirstScreen extends ConsumerWidget {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneNumCtrl = TextEditingController(text: "+963");
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final register = ref.watch(AuthNotifierProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final AppLocalizations t = AppLocalizations.of(context)!;

    final bgAsset = switch ((isRtl, isDark)) {
      (false, false) => 'assets/images/backgrounds/register_light_bg.svg',
      (false, true) => 'assets/images/backgrounds/register_dark_bg.svg',
      (true, false) => 'assets/images/backgrounds/rtl_register_light_bg.svg',
      (true, true) => 'assets/images/backgrounds/rtl_register_dark_bg.svg',
    };

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
  resizeToAvoidBottomInset: true,
  body: GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),//for unfocusing from textfields
    child: Stack(
      children: [
        SizedBox.expand( // to make it fit all sizes
          child: SvgPicture.asset(bgAsset, fit: BoxFit.cover),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.05,
              screenHeight * 0.02,
              screenWidth * 0.05,
              screenHeight * 0.02 + MediaQuery.of(context).viewInsets.bottom,
            ),

            // SafeArea(
            //   child: SingleChildScrollView(
            //     padding: EdgeInsets.fromLTRB(
            //       screenWidth * 0.05,
            //       screenHeight * 0.02,
            //       screenWidth * 0.05,
            //       screenHeight * 0.02 +
            //           MediaQuery.of(context).viewInsets.bottom,
            //     ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50 * screenHeight / 1920),

                    Text(
                      t.register_title,
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontSize: isRtl ? screenWidth * 0.1 : screenWidth * 0.15,
                        fontFamily: 'Monoglyceride',
                      ),
                    ),

                    SizedBox(height: isRtl ? screenWidth * 0.13 : screenWidth * 0.05),

                    Text(
                      t.register_firstNameLabel,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    SizedBox(
                      height: screenHeight * 0.07,
                      child: MyTextField(
                        controller: _firstNameCtrl,
                        hintText: t.register_firstNameHint,
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.013),

                    Text(
                      t.register_lastNameLabel,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    SizedBox(
                      height: screenHeight * 0.07,
                      child: MyTextField(
                        controller: _lastNameCtrl,
                        hintText: t.register_lastNameHint,
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.013),

                    Text(
                      t.phoneLabel,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    SizedBox(
                      height: screenHeight * 0.07,
                      child: Directionality
                      (
                        textDirection: TextDirection.ltr,
                        child: MyTextField(
                          controller: _phoneNumCtrl,
                          hintText: "+963-000-000-000",
                          keyboardType: TextInputType.phone,
                          maxLength: 13,
                        ),
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
                    SizedBox(
                      height: screenHeight * 0.07,
                      child: MyTextField(
                        controller: _passwordCtrl,
                        hintText: " * * * * * * * * ",
                        obscureText: true,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.019),

                    PrimaryButton(
                      label: t.register_continue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterSecondScreen(
                              firstName: _firstNameCtrl.text,
                              lastName: _lastNameCtrl.text,
                              phoneNum: _phoneNumCtrl.text,
                              password: _passwordCtrl.text,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: screenHeight * 0.021,
                        ),
                        children: [
                           TextSpan(
                            text:  t.register_haveAccount,
                          ),
                          TextSpan(
                            text: t.here,
                            style: TextStyle(
                              color: cs.secondary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  "SignInPage",
                                );
                              },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.08),
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
