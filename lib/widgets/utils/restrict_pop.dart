import 'package:flutter/material.dart';

class RestrictPop extends StatelessWidget {
  final Widget child;
  final String title;
  final String content;
  final String positiveActionText;
  final String negativeActionText;
  final void Function()? onPositiveAction;
  final void Function()? onNegativeAction;

  const RestrictPop({
    super.key,
    required this.child,
    this.title = "Exit Confirmation",
    this.content = "Are you sure you want to exit this page?",
    this.positiveActionText = "Yes",
    this.negativeActionText = "No",
    this.onPositiveAction,
    this.onNegativeAction,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool invoked) async {
        if (invoked) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onNegativeAction != null) {
                    onNegativeAction!();
                  }
                },
                child: Text(negativeActionText),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  if (onPositiveAction != null) {
                    onPositiveAction!();
                  }
                },
                child: Text(positiveActionText),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
