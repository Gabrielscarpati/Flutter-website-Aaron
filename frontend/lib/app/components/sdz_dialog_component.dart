import 'package:flutter/material.dart';

import 'sdz_button.dart';

class SdzDialogComponent extends StatefulWidget {
  final String title;
  final String content;
  final void Function() onConfirm;
  final String buttonConfirmText;
  final bool? isExitButton;

  const SdzDialogComponent({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.buttonConfirmText,
    this.isExitButton,
  });

  @override
  State<SdzDialogComponent> createState() => _SdzDialogComponentState();
}

class _SdzDialogComponentState extends State<SdzDialogComponent> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.content),
      surfaceTintColor: Colors.transparent,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5)),
      actions: [
        SdzButton(
          text: 'Cancelar',
          isBack: true,
          onTap: () async => Navigator.pop(context),
        ),
        SdzButton(
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
