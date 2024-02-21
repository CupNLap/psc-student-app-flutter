import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gobal/constants.dart';
import '../gobal/crash_consts.dart';
import '../provider/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/utils/gap.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logPageName('profile_screen.dart');

    return Scaffold(
      backgroundColor: AppTheme.background,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(AppTheme.largeGutter),
                    RoundedImageWithBorder(
                      image: currentUser.photoURL != null
                          ? CachedNetworkImageProvider(currentUser.photoURL!)
                              as ImageProvider
                          : AssetImage(
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
                    ProfileItem(
                      title: "Phone",
                      content: currentUser.phoneNumber,
                    ),

                    ProfileItem(
                      title: "Email",
                      content: currentUser.email,
                      onPressed: currentUser.email != null &&
                              currentUser.email!.isNotEmpty
                          ? null
                          : () async {
                              if (!currentUser.emailVerified) {
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .signInWithGoogle();
                                Navigator.pop(context);
                              }
                            },
                    ),
                    // Link with the email, if not connected yet
                    if (!currentUser.emailVerified) ...[
                      Gap(AppTheme.smallGutter),
                      CustomButton(
                        buttonColor: Colors.white,
                        color: Colors.red,
                        icon: Icons.insert_link_outlined,
                        text: "Link Google Account",
                        onPressed: () {
                          Provider.of<UserProvider>(context, listen: false)
                              .signInWithGoogle();
                        },
                      ),
                      Gap(AppTheme.largeGutter),
                    ],
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
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return onPressed == null
        ? buildContentView()
        : Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildContentView(),
              // CustomButton(
              //     icon: Icons.arrow_right_alt_rounded,
              //     text: "Link Email",
              //     onPressed: () => onPressed),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.arrow_right_alt_rounded,
                      color: AppTheme.textBody)),
            ],
          );
  }

  Container buildContentView() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(AppTheme.smallGutter),
          Text(
            title,
            style: TextStyle(color: AppTheme.textTitle),
          ),
          Text(
            content ?? "---",
            style: TextStyle(color: AppTheme.textBody, fontFamily: 'Poppins'),
          ),
          Divider(
            color: AppTheme.divider,
          ),
          Gap(AppTheme.smallGutter),
        ],
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
  final Color color;

  const CustomButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    this.buttonColor = Colors.green,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite, // Utilize full width
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(2.0, 4.0),
            blurRadius: 8.0,
          ),
        ]),
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            foregroundColor: MaterialStateProperty.all(color),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              SizedBox(width: 8),
              Icon(icon, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
