import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/widgets/my_text_field.dart';
import '../widgets/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phoneCtrl = TextEditingController(); //these are used to write in the textfield n clear it n take input 
  final _passCtrl = TextEditingController();
  double w(double px) => px * MediaQuery.of(context).size.width / 1080;
  
 
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgAsset = isDark
        ? 'assets/images/backgrounds/signin_dark_bg.svg'
        : 'assets/images/backgrounds/signin_light_bg.svg';
        //to put the correct bg

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      
      body: Stack //to put the bg svg under the rest
      (
        children:[
          Positioned.fill(
            child: SvgPicture.asset(
              bgAsset,
              fit: BoxFit.fill, 
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200 * screenHeight / 1920),

                Text(
                  "Sign in",
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: screenWidth * 0.15,
                    fontFamily: 'Monoglyceride',
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),

                Text("Phone Number", style: TextStyle(color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:screenWidth * 0.04 )),

                SizedBox(height: screenHeight * 0.003),

                MyTextField(
                  controller: _phoneCtrl,
                  hintText: "+963-000-000-000",
                  keyboardType: TextInputType.phone,
                ),
                  
                SizedBox(height: screenHeight * 0.013),
                  
                Text("Password", style: TextStyle(color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:screenWidth * 0.04)),

                SizedBox(height: screenHeight * 0.003),

                MyTextField(
                  controller: _passCtrl,
                  hintText: "********",
                  obscureText: true,
                ),
                  
                SizedBox(height: screenHeight * (22 / 1920)),
                  
                PrimaryButton(
                  label: "Sign In",
                  onPressed: (){},  
                ),
                  
                SizedBox(height: screenHeight * (16 / 1920)),
                  
                Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,fontSize:screenWidth * 0.03,
                    color: cs.secondary,
                    decoration: TextDecoration.underline,
                  ),
                  
                ),
                SizedBox(height: screenHeight * (100 / 1920)),
              ],
            ),
          ),
        ] 
      ),
    );
  }
}
