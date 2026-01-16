import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project/generated/l10n/app_localizations.dart';
import 'package:project/widgets/date_text_field.dart';
import 'package:project/widgets/primary_button.dart';
import 'package:project/widgets/upload_box.dart';

import '../generated/l10n/app_localizations.dart';
import '../models/AuthState.dart';
import '../providers/auth_provide.dart';

class RegisterSecondScreen extends ConsumerStatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? phoneNum;
  final String? password;
  RegisterSecondScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.phoneNum,
    this.password,
  });

  @override
  ConsumerState<RegisterSecondScreen> createState() =>
      _RegisterSecondScreenState();
}

class _RegisterSecondScreenState extends ConsumerState<RegisterSecondScreen> {
  final _birthdateCtrl = TextEditingController();

  DateTime? _birthdate;
  File? _profileImage; //these are stored as normal files for display only :)
  File? _idImage;
  XFile?
  _idImageXfile; //we'll use these when we send pic to backend (convert to bits? then send via dio)
  XFile? _profileImageXfile;

  String? _birthdateError;
  String? _profileError;
  String? _idError;

  bool _validateStep2() {
    setState(() {
      _birthdateError = (_birthdate == null) ? "Required" : null;
      _profileError = (_profileImageXfile == null) ? "Required" : null;
      _idError = (_idImageXfile == null) ? "Required" : null;
    });

    return _birthdateError == null && _profileError == null && _idError == null;
  }

  final _picker =
      ImagePicker(); //important for image picker package..only used in its func

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
          data: Theme.of(context).copyWith(colorScheme: cs),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _birthdate = picked;
      _birthdateCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      _birthdateError = null;
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
                title: Text(
                  AppLocalizations.of(context)!.register2_pickCamera,
                  style: TextStyle(color: cs.onSurface),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: cs.onSurface),
                title: Text(
                  AppLocalizations.of(context)!.register2_pickGallery,
                  style: TextStyle(color: cs.onSurface),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final picked = await _picker.pickImage(source: source, imageQuality: 85);
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
        _profileError = null;
      } else {
        _idImage = file;
        _idError = null;
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
    final AppLocalizations t = AppLocalizations.of(context)!;

    final register = ref.watch(AuthNotifierProvider);
    ref.listen<AuthState>(AuthNotifierProvider, (previous, next) {
      // to react when the state changes
      if (next.status == AuthStatus.error) {
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
            duration: Duration(seconds: 3),
          ),
        );
      } else if (next.status == AuthStatus.waiting) {
        print("waiting");

        Navigator.pushReplacementNamed(context, 'SignInPage');
      }
    });

    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    final bgAsset = switch ((isRtl, isDark)) {
      (false, false) => 'assets/images/backgrounds/register_light_bg.svg',
      (false, true) => 'assets/images/backgrounds/register_dark_bg.svg',
      (true, false) => 'assets/images/backgrounds/rtl_register_light_bg.svg',
      (true, true) => 'assets/images/backgrounds/rtl_register_dark_bg.svg',
    };
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SizedBox.expand(child: SvgPicture.asset(bgAsset, fit: BoxFit.fill)),
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
                  t.register_title,
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: isRtl ? screenWidth * 0.1 : screenWidth * 0.15,
                    fontFamily: 'Monoglyceride',
                  ),
                ),

                SizedBox(
                  height: isRtl ? screenWidth * 0.13 : screenWidth * 0.05,
                ),

                // Birthdate label
                Text(
                  t.register2_birthdateLabel,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),

                MyDateField(
                  controller: _birthdateCtrl,
                  hintText: t.register2_birthdateHint,
                  onTap: _pickBirthdate,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Profile picture
                Text(
                  t.register2_profilePictureLabel,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                UploadBox(
                  imageFile: _profileImage,
                  onTap: () => _pickImage(isProfile: true),
                ),
               
                SizedBox(height: screenHeight * 0.03),

                // ID picture
                Text(
                  t.register2_idPictureLabel,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                  ),
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
                      ? t.loading
                      : t.register_title,
                  onPressed: register.status == AuthStatus.loading
                      ? null
                      : () async {
                          if (!_validateStep2()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text(
                                  t.register_fillAllFields
                                ),
                              ),
                            );
                            return;
                          }
                          print(widget.firstName);
                          print(widget.lastName);
                          print(widget.password);
                          print(widget.phoneNum);
                          print(_birthdate?.toIso8601String());
                          print(_profileImageXfile!.path);

                          final phone = widget.phoneNum!.trim();

                          final countryCode = phone.length >= 4
                              ? phone.substring(0, 4)
                              : phone;
                          final phoneNumber = phone.length > 4
                              ? phone.substring(4)
                              : "";

                          // _submit();
                          // here we consume the sign in provider bro
                          // when pressed, read the data
                          ref
                              .read(AuthNotifierProvider.notifier)
                              .auth(
                                authType: AuthType.register,
                                dataMap: {
                                  "first_name": widget.firstName,
                                  "last_name": widget.lastName,
                                  "country_code": countryCode,
                                  "phone_number": phoneNumber,
                                  "password": widget.password,
                                  "password_confirmation": widget.password,
                                  "birth_date": _birthdate?.toIso8601String(),
                                  "legal_photo": await MultipartFile.fromFile(
                                    _profileImageXfile!.path,
                                    filename: _profileImageXfile!.name,
                                  ),
                                  "legal_doc": await MultipartFile.fromFile(
                                    _idImageXfile!.path,
                                    filename: _idImageXfile!.name,
                                  ),
                                },
                              );
                        },
                ),
                SizedBox(height: screenHeight * 0.05),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: screenHeight * 0.021,
                    ),
                    children: [
                      TextSpan(text: t.register_haveAccount),
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
                            Navigator.pushNamed(context, "SignInPage");
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
