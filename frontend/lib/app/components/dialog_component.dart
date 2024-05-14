import 'package:flutter/material.dart';

import 'button_component.dart';

class DialogComponent extends StatefulWidget {
  final String title;
  final String content;
  final void Function() onConfirm;
  final String buttonConfirmText;
  final bool? isExitButton;

  const DialogComponent({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.buttonConfirmText,
    this.isExitButton,
  });

  @override
  State<DialogComponent> createState() => _DialogComponentState();
}

class _DialogComponentState extends State<DialogComponent> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      surfaceTintColor: Colors.transparent,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: [
        ButtonComponent(
          text: 'Abort',
          isBack: true,
          onTap: () async => Navigator.pop(context),
        ),
        ButtonComponent(
          text: widget.buttonConfirmText,
          onTap: () async {
            widget.onConfirm.call();
          },
          isExit: widget.isExitButton,
        ),
      ],
    );
  }
}
