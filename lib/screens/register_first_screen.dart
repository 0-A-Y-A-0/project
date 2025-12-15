import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/widgets/my_text_field.dart';

import '../widgets/primary_button.dart';

class RegisterFirstScreen extends StatefulWidget {
  const RegisterFirstScreen({super.key});
  //
  @override
  State<RegisterFirstScreen> createState() => _RegisterFirstScreenState();
}

//
class _RegisterFirstScreenState extends State<RegisterFirstScreen> {
  // class RegisterFirstScreen extends ConsumerWidget {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneNumCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgAsset = isDark
        ? 'assets/images/backgrounds/register_dark_bg.svg'
        : 'assets/images/backgrounds/register_light_bg.svg';
    //to put the correct bg

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body:
          Stack //to put the bg svg under the rest
          (
            children: [
              Positioned.fill(
                child: SvgPicture.asset(bgAsset, fit: BoxFit.fill),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100 * screenHeight / 1920),

                    Text(
                      "Register",
                      style: TextStyle(
                        color: cs.onPrimary,
                        fontSize: screenWidth * 0.15,
                        fontFamily: 'Monoglyceride',
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    Text(
                      "First Name",
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.003),

                     SizedBox(
                      height: screenHeight * 0.07,
                      child: 
                    MyTextField(
                      controller: _firstNameCtrl,
                      hintText: "first name",
                      keyboardType: TextInputType.phone,
                    ),),

                    SizedBox(height: screenHeight * 0.013),

                    Text(
                      "Last Name",
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.003),

                     SizedBox(
                      height: screenHeight * 0.07,
                      child: 
                    MyTextField(
                      controller: _lastNameCtrl,
                      hintText: "last name",
                      keyboardType: TextInputType.phone,
                    ),),

                    SizedBox(height: screenHeight * 0.013),

                    Text(
                      "Phone number",
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.003),

                    SizedBox(
                      height: screenHeight * 0.07,
                      child: 
                    MyTextField(
                      controller: _phoneNumCtrl,
                      hintText: "+963-000-000-000",
                      keyboardType: TextInputType.phone,
                    ),
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
                      label: 'Continue',
                      onPressed: () {
                                //well change this to provider things
                                Navigator.pushReplacementNamed(
                                  context,
                                  "RegisterSecondPage"
                                );
                              },
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    RichText(//lets us write text in chunks/to change the style etc..
                      text: TextSpan(
                        style: TextStyle(color: cs.onSurface, fontSize: screenHeight * 0.021),
                        children: [
                          const TextSpan(//one chunk of text
                            text: "Already have an account?\nsign in ",
                          ),
                          TextSpan(
                            text: "here",
                            style: TextStyle(
                              color: cs.secondary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  "SignInPage"
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
