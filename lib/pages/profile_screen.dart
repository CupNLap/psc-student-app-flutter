import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student/gobal/constants.dart';
import 'package:student/theme/app_theme.dart';
import 'package:student/widgets/utils/gap.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side bar
          Container(
            color: AppTheme.accentColor,
            width: 100,
          ),
          // Content container
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              color: AppTheme.background,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(AppTheme.largeGutter),
                    RoundedImageWithBorder(
                      image: AssetImage(
                          "assets/images/avatar/avatar${new Random().nextInt(4) + 1}.png"),
                      borderRadius: AppTheme.largeRadius,
                    ),

                    Text(currentUser.uid,
                        style: Theme.of(context).textTheme.bodySmall),

                    Gap(AppTheme.largeGutter),
                    ProfileItem(
                      title: "Name",
                      content: currentUser.displayName,
                    ),
                    // Link with the email, if not connected yet

                    ProfileItem(
                      title: "Email ${currentUser.emailVerified}",
                      content: currentUser.email,
                      onPressed: () {
                        if (!currentUser.emailVerified) {
                          Future<UserCredential?> signInWithGoogle() async {
                            // Trigger the authentication flow
                            final GoogleSignInAccount? googleUser =
                                await GoogleSignIn().signIn();

                            // Obtain the auth details from the request
                            final GoogleSignInAuthentication? googleAuth =
                                await googleUser?.authentication;

                            // Create a new credential
                            final credential = GoogleAuthProvider.credential(
                              accessToken: googleAuth?.accessToken,
                              idToken: googleAuth?.idToken,
                            );

                            print(credential);
                            var d = await FirebaseAuth.instance.currentUser
                                ?.linkWithCredential(credential);

                            print(d);
                            return d;
                            // // Once signed in, return the UserCredential
                            // return await FirebaseAuth.instance
                            //     .signInWithCredential(credential);
                          }

                          signInWithGoogle();
                        }
                      },
                    ),
                    ProfileItem(
                      title: "Phone",
                      content: currentUser.phoneNumber,
                    ),
                    CustomButton(
                      icon: Icons.upload_rounded,
                      text: "Update Profile",
                      onPressed: () {},
                    ),
                    CustomButton(
                        icon: Icons.logout,
                        text: "Logout",
                        buttonColor: Colors.red,
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.title,
    this.content,
    this.onPressed,
  });

  final String title;
  final String? content;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed?.call(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(AppTheme.smallGutter),
            Text(
              title,
              style:
                  TextStyle(color: AppTheme.textTitle, fontFamily: 'Poppins'),
            ),
            Text(
              content ?? "---",
              style: TextStyle(color: AppTheme.textBody),
            ),
            Divider(
              color: AppTheme.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedImageWithBorder extends StatelessWidget {
  final ImageProvider image;
  final double borderRadius;
  final double borderWidth;

  const RoundedImageWithBorder({
    required this.image,
    this.borderRadius = 10.0, // Top right corner radius
    this.borderWidth = 2.0, // Border width in pixels
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(borderRadius)),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Image(
          image: image,
          fit: BoxFit
              .cover, // Fills the aspect ratio while maintaining image content
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;

  const CustomButton(
      {required this.icon,
      required this.text,
      required this.onPressed,
      this.buttonColor = Colors.green});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Utilize full width
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(4.0, 4.0),
            blurRadius: 4.0,
          ),
        ]),
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 8),
              Text(text, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
