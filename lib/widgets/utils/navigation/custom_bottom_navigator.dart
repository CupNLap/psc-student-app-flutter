import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import '../../../gobal/constants.dart';
import '../../../pages/profile_screen.dart';
import '../../../provider/user_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../gap.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<TabItem> tabItems = TabItem.tabItems;
  SMIBool? status;

  void _onRiveIconInit(Artboard artboard, int index) {
    print('Print all animations');
    for (final animation in artboard.animations) {
      print(animation.name);
    }

    final controller = StateMachineController.fromArtboard(
      artboard,
      tabItems[index].stateMachine,
    );
    if (controller != null) {
      artboard.addController(controller);

      tabItems[index].status = controller.findInput<bool>("active") as SMIBool;
    }
  }

  void onTabNavigationItem(int index) {
    tabItems[index].status?.change(true);
    Future.delayed(Duration(seconds: 5), () {
      tabItems[index].status?.change(false);
    });

    // Perform the action
    if (tabItems[index].onClick != null) {
      tabItems[index].onClick!();
    }
    if (tabItems[index].path != null) {
      context.push(tabItems[index].path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // This container will act as a gradient border
      child: Container(
        margin: EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [Colors.white54, Colors.white10],
            )),
        // This container will contain the content
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!currentUser.emailVerified) ...[
              Gap(),
              Text(
                  "Login with moblie number will be removed soon\nSo it is recommeded to link your account with your email, click the bellow button to link the email"),
              Gap(),
              CustomButton(
                buttonColor: Colors.red,
                icon: Icons.email,
                onPressed: () async {
                  try {
                    await Provider.of<UserProvider>(context, listen: false)
                        .signInWithGoogle();
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Error occured \n${e.email} \n${e.message}'),
                        duration: Duration(seconds: 10),
                      ),
                    );
                  }
                },
                text: "Link Your Email",
              ),
              Gap(50),
            ],
            Container(
              decoration: BoxDecoration(
                  color: AppTheme.background2.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.background2.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 20),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                  tabItems.length,
                  (index) => CupertinoButton(
                    padding: EdgeInsets.all(12),
                    onPressed: () => onTabNavigationItem(index),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: RiveAnimation.asset(
                        'assets/rive_app/rive/icons.riv',
                        stateMachines: [tabItems[index].stateMachine],
                        artboard: tabItems[index].artboard,
                        onInit: (artboard) => _onRiveIconInit(artboard, index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabItem {
  TabItem({
    this.stateMachine = "",
    this.artboard = "",
    this.onClick,
    this.path,
    this.status,
  });

  UniqueKey? id = UniqueKey();
  String stateMachine;
  String artboard;
  Function? onClick;
  String? path;
  late SMIBool? status;

  static List<TabItem> tabItems = [
    TabItem(stateMachine: "HOME_interactivity", artboard: "HOME"),
    // TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"),
    // TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"),
    // TabItem(stateMachine: "TIMER_Interactivity", artboard: "TIMER"),
    // TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"),
    TabItem(
        stateMachine: "USER_Interactivity",
        artboard: "USER",
        path: AppRoutes.profileRoute),
  ];
}
