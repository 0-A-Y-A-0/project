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
  final _phoneCtrl = TextEditingController(); //these are used to write in the textfield n clear it n take input
  final _passCtrl = TextEditingController();
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(AuthNotifierProvider); // for rebuilding ui
    ref.listen<AuthState>(AuthNotifierProvider, (previous, next) { // to react when the state changes
      if (next.status == AuthStatus.completed) {
        // Navigate to search screen
        Navigator.pushReplacementNamed(context,'SearchPage');

      } else if (next.status == AuthStatus.error) {
        // Show a pop up with error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('ERROR !!! Try again later', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: Duration(seconds: 3),
          ),
        );
      }else if (next.status == AuthStatus.waiting){
        // here we'll do something
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
                SizedBox(height: 150 * screenHeight / 1920),

                Text(
                  "Sign in",
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: screenWidth * 0.15,
                    fontFamily: 'Monoglyceride',
                  ),
                ),

                SizedBox(height: screenHeight * 0.11),

                Text("Phone Number", style: TextStyle(
                    color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:screenWidth * 0.04),
                ),

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
                  hintText: " * * * * * * * *",
                  obscureText: true,
                ),
                  
                SizedBox(height: screenHeight * 0.02),
                  
                PrimaryButton(
                  // change the text if it's loading 
                  label: signIn.status == AuthStatus.loading
                        ? "Loading ..."
                        : "Sign In",
                  onPressed: (){
                    // here we consume the sign in provider bro
                    // when pressed, read the data
                    ref.read(AuthNotifierProvider.notifier).signIn(
                      authType: AuthType.sign_in,
                      dataMap: {
                        "phone": _phoneCtrl.text,
                        "password": _passCtrl.text}
                    ) ;
                  },
                ),

                SizedBox(height: screenHeight * 0.02),

                Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,fontSize:screenWidth * 0.04,
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
