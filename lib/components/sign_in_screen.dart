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
  
 
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 56,
                    fontFamily: 'Monoglyceride',
                  ),
                ),
                const SizedBox(height: 55),
                Text("Phone Number", style: TextStyle(color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:18 )),
                const SizedBox(height: 8),
                MyTextField(
                  controller: _phoneCtrl,
                  hintText: "+963-000-000-000",
                  keyboardType: TextInputType.phone,
                ),
                  
                const SizedBox(height: 20),
                  
                Text("Password", style: TextStyle(color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:18)),
                const SizedBox(height: 8),
                MyTextField(
                  controller: _passCtrl,
                  hintText: "********",
                  obscureText: true,
                ),
                  
                const SizedBox(height: 22),
                  
                PrimaryButton(
                  label: "Sign In",
                  onPressed: (){},  
                ),
                  
                const SizedBox(height: 16),
                  
                Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,fontSize:18,
                    color: cs.secondary,
                    decoration: TextDecoration.underline,
                  ),
                  
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ] 
      ),
    );
  }
}
