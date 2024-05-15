import 'package:flutter/material.dart';

import 'button_component.dart';

class DialogComponent extends StatefulWidget {
  final String title;
  final Widget content;
  final void Function()? onConfirm;
  final String? buttonConfirmText;
  final bool? isExitButton;

  const DialogComponent({
    super.key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.buttonConfirmText,
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
      content: Container(
        constraints: (widget.content is StatefulWidget)
            ? BoxConstraints(
                minWidth: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width / 5),
              )
            : null,
        child: widget.content,
      ),
      surfaceTintColor: Colors.transparent,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: [
        ButtonComponent(
          text: 'Dismiss',
          isBack: true,
          onTap: () async => Navigator.pop(context),
        ),
        widget.onConfirm != null
            ? ButtonComponent(
                text: widget.buttonConfirmText ?? 'Confirm',
                onTap: () async {
                  widget.onConfirm!.call();
                },
                isExit: widget.isExitButton,
              )
            : const SizedBox(),
      ],
    );
  }
}
