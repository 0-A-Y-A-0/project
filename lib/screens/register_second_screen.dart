import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project/screens/register_first_screen.dart';
import 'package:project/widgets/date_text_field.dart';
import 'package:project/widgets/primary_button.dart';
import 'package:project/widgets/upload_box.dart';

import '../models/AuthState.dart';
import '../providers/auth_provide.dart';

class RegisterSecondScreen extends ConsumerStatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? phoneNum;
  final String? password;
  RegisterSecondScreen({super.key, this.firstName, this.lastName, this.phoneNum, this.password});

  @override
  ConsumerState<RegisterSecondScreen> createState() => _RegisterSecondScreenState();
}

class _RegisterSecondScreenState extends ConsumerState<RegisterSecondScreen> {
  final _birthdateCtrl = TextEditingController();

  DateTime? _birthdate;
  File? _profileImage;//these are stored as normal files for display only :)
  File? _idImage;
  XFile? _idImageXfile; //we'll use these when we send pic to backend (convert to bits? then send via dio)
  XFile? _profileImageXfile;

  final _picker = ImagePicker(); //important for image picker package..only used in its func
  
  //date dialog future func
  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final initial = _birthdate ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select birthdate',
      
      builder: (context, child) {
        final cs = Theme.of(context).colorScheme;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: cs,
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _birthdate = picked;
      _birthdateCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }
 
 //image picker future
  Future<void> _pickImage({required bool isProfile}) async {
    //makes the thing at the bottom
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera, color: cs.onSurface),
                title: Text('Camera', style: TextStyle(color: cs.onSurface)),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: cs.onSurface),
                title: Text('Gallery', style: TextStyle(color: cs.onSurface)),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) return;

    //just saving the xfile here for later 
    if (isProfile) {
        _profileImageXfile = picked;
      } else {
        _idImageXfile = picked;
      }

    setState(() {
      final file = File(picked.path);
      if (isProfile) {
        _profileImage = file;
      } else {
        _idImage = file;
      }
    });
  }

  //checking if life is worth living 
  // void _submit() {
  //   // well connect this to backend later
  //   if (_birthdate == null || _profileImage == null || _idImage == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('please fill all fields idiot')),
  //     );
  //     return;
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('yayyy registered! (we will take your soul)')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final register = ref.watch(AuthNotifierProvider);

    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bgAsset = isDark
        ? 'assets/images/backgrounds/register_dark_bg.svg'
        : 'assets/images/backgrounds/register_light_bg.svg';

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
                child: SvgPicture.asset(bgAsset, fit: BoxFit.fill),
              ),
          SingleChildScrollView(
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
          
                
                // Birthdate label
                Text(
                  "Birthdate",
                  style: TextStyle(color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:screenWidth * 0.04 ),
                ),
                SizedBox(height: screenHeight * 0.003),
                
                MyDateField(controller: _birthdateCtrl, hintText: "dd/mm/yyyy", onTap: _pickBirthdate),
                
                
                SizedBox(height: screenHeight * 0.03),
                
                // Profile picture
                Text(
                  "profile picture",
                  style: TextStyle(color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.003),
                UploadBox(
                  imageFile: _profileImage,
                  onTap: () => _pickImage(isProfile: true),
                ),
                
                SizedBox(height: screenHeight * 0.03),
                
                // ID picture
                Text(
                  "ID picture",
                  style: TextStyle(color: cs.onSurface,fontWeight: FontWeight.w700,fontSize:screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.003),
                UploadBox(
                  imageFile: _idImage,
                  onTap: () => _pickImage(isProfile: false),
                ),
                
                SizedBox(height: screenHeight * 0.04),
                
                // Register button (matches your button styling via theme)
                PrimaryButton(
                  // change the text if it's loading
                  label: register.status == AuthStatus.loading
                        ? "Loading ..."
                        : "Sign In",
                  onPressed: () async {
                    // _submit();
                    // here we consume the sign in provider bro
                    // when pressed, read the data
                    ref.read(AuthNotifierProvider.notifier).auth(
                        authType: AuthType.register,
                        dataMap: {
                          "first_name" : widget.firstName,
                          "last_name" : widget.lastName,
                          "phone" : widget.phoneNum,
                          "password" : widget.password,
                          "birthdate" : _birthdate,
                          "profile_image":  await MultipartFile.fromFile(
                              _profileImageXfile!.path,
                              filename: _profileImageXfile!.name),
                          "id_image":  await MultipartFile.fromFile(
                              _idImageXfile!.path,
                              filename: _idImageXfile!.name),
                        }
                    );
                    Navigator.pushReplacementNamed(context, 'SignInPage');
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
                RichText(
                    text: TextSpan(
                      style: TextStyle(color: cs.onSurface, fontSize: screenHeight * 0.021),
                      children: [
                        const TextSpan(
                          text: "Already have an account?\nsign in",
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
                              //well change this to provider things
                              Navigator.pushNamed(
                                context,
                                "SignInPage"
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


