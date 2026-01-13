import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:project/screens/favorite_screen.dart';
import 'package:project/widgets/primary_button.dart';
import 'package:project/widgets/profile_list_button.dart';
import 'package:project/widgets/profile_list_container.dart';
import 'package:project/widgets/theme_switch.dart';

import '../models/AuthState.dart';
import '../providers/auth_provide.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final user = ref.watch(UserProvider);
    final imageUrl = user?.photo_url != null
        ? 'http://10.0.2.2:8000/storage/${user!.photo_url}'
        : null;


    final isRtl = Directionality.of(context) == TextDirection.rtl;
     final logoutIconPath = isRtl
        ? "assets/icons/rtl_log_out_icon.png"
        : "assets/icons/log_out_icon.png";

     // to avoid red screen when logging out 👍
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: cs.onPrimary,
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile img and editing it
          Row(
            children: [
              // the pic
              Container(
                height: screenHeight / 4,
                width: screenHeight / 4,
                margin: EdgeInsetsDirectional.only(start: screenWidth * 0.02, end: screenWidth * 0.03),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.secondary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(cs.brightness == Brightness.dark ? 100 : 60),
                      blurRadius: screenWidth * 0.05,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),

                child: ClipOval(
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/images/apartments/test.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/images/apartments/test.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),

                  // user name
                  Text(
                    "${user?.first_name} ${user?.last_name}",
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Monoglyceride',
                    ),
                  ),

                  SizedBox(height: 5),

                  // bio
                  SizedBox(
                    // we have to force a width so the text wrap works ... remove it if you want to see yellow flags 🚧
                    width: screenWidth * 0.46,
                    child: Text(
                      user!.bio! ,
                      // "this is me testing the overflow text wrap i don't know what im writing i just want to fill some space and bla bla bla bla i hope its more than two lines now are you open mindu?",
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'BellotaText',
                      ),

                      // if the bio is too long this only shows x lines and adds ...
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),

                  SizedBox(height: 20),

                  // edit button
                  Container(
                    height: screenHeight * 0.055,
                    width: screenWidth * 0.45,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 1.5, color: cs.primary.withAlpha(150)),
                        backgroundColor: cs.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      
                      icon: Icon(Icons.edit, color: cs.primary.withAlpha(200)),
                      
                      label: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Monoglyceride',
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.04),

          // History
          createText(color: cs.primary.withAlpha(150), text: "History"),
          ListContainer(
            child: Column(
              children: [
                ListButton(
                  text: "My apartments",
                  iconPath: 'assets/icons/apartment_icon.png',
                  onPressed: () {
                    print("clicked");
                  },
                ),

                createDivider(
                    cs.brightness == Brightness.dark ? Colors.grey.withAlpha(50) : Colors.grey.withAlpha(150)
                ),

                ListButton(
                  text: "Favorites",
                  iconPath: 'assets/icons/fav_icon.png',
                  onPressed: () {
                    print("clicked");
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: FavoriteScreen(),
                        withNavBar: false );
                  },
                ),

                createDivider(
                    cs.brightness == Brightness.dark ? Colors.grey.withAlpha(50) : Colors.grey.withAlpha(150)
                ),

                ListButton(
                  text: "Rental history",
                  iconPath: 'assets/icons/history_icon.png',
                  onPressed: () {
                    print("clicked");
                  },
                ),
              ],
            ),
          ),

          // App
          // im sorry i was too lazy to tidy this up
          createText(color: cs.primary.withAlpha(150), text: "App"),
          ListContainer(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                        "Theme",
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'BellotaText',
                        )
                    ),

                    // Spacer(flex: 1,),
                    SizedBox(width: screenWidth * 0.55,),

                    ThemeToggle(),
                  ],
                ),

                createDivider(
                    cs.brightness == Brightness.dark ? Colors.grey.withAlpha(50) : Colors.grey.withAlpha(150)
                ),

                Stack(
                  children: [
                    Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                    
                      
                      children: [
                        ImageIcon(
                          AssetImage(logoutIconPath),
                          color: cs.primary.withAlpha(200),
                          size: screenWidth * 0.07,
                        ),

                        Spacer(flex: 1,),

                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                              "Log Out",
                              style: TextStyle(
                                color: cs.primary,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                fontFamily: 'BellotaText',
                              )
                          ),
                        ),
                        // SizedBox(width: screenWidth * 0.02),
                        Spacer(flex: 20,),
                      ],
                    ),
                  ),

                    
                    Positioned.fill(
                      right: screenWidth * 0.03, // the right gap
                      bottom: 2,
                      top: 1,
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: (){
                              print("clicked -----------------------------");
                              ref.read(AuthNotifierProvider.notifier).logout();
                              // navigating is happening in the main screen
                            },
                            splashColor: cs.primary.withAlpha(50), // to make the splash color matchy matchy
                          )
                      ),
                    ),
                  ]
                )
              ],
            ),
          ),

          // Help
          createText(color: cs.primary.withAlpha(150), text: "Help"),
          ListContainer(
            child: Column(
              children: [
                ListButton(
                  text: "Send feedback",
                  iconPath: 'assets/icons/send_icon.png',
                  onPressed: () {
                    print("clicked");
                  },
                ),

                createDivider(
                    cs.brightness == Brightness.dark ? Colors.grey.withAlpha(50) : Colors.grey.withAlpha(150)
                ),

                ListButton(
                  text: "Privacy Policy",
                  iconPath: 'assets/icons/security_icon.png',
                  onPressed: () {
                    print("clicked");
                  },
                ),

                createDivider(
                    cs.brightness == Brightness.dark ? Colors.grey.withAlpha(50) : Colors.grey.withAlpha(150)
                ),

                ListButton(
                  text: "About us",
                  iconPath: 'assets/icons/info_icon.png',
                  onPressed: () {
                    print("clicked");
                  },
                ),
              ],
            ),
          ),

          // the most important part
          Text(
            "my app v2.3.5 (12548)",
            style: TextStyle(
              color: cs.primary.withAlpha(120),
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'BellotaText',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Divider createDivider(Color color) {
    return Divider(
      height: 5,
      thickness: 1,
      color: color,
      endIndent: 15,
    );
  }

  Padding createText({required Color color, required String text}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w400,
            fontSize: 17,
            fontFamily: 'Monoglyceride',
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
