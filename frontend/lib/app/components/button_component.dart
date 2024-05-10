import 'package:flutter/material.dart';

class ButtonComponent extends StatefulWidget {
  final String text;
  final Future<void> Function()? onTap;
  final bool? isBack;
  final bool? isExit;

  const ButtonComponent({
    super.key,
    required this.text,
    required this.onTap,
    this.isBack,
    this.isExit,
  });

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: widget.isBack ?? false
          ? Icon(
              Icons.close,
              size: 16,
              weight: 500,
              color: Colors.grey.shade200,
            )
          : !(widget.isExit ?? false)
              ? Icon(Icons.check, size: 16, color: Colors.grey.shade200)
              : Icon(
                  Icons.logout,
                  color: Colors.grey.shade200,
                  size: 16,
                ),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        if (widget.onTap != null) {
          await widget.onTap!();
          setState(() {
            isLoading = false;
          });
        }
      },
      label: Text(
        widget.text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade200,
        ),
      ),
      style: TextButton.styleFrom(
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          backgroundColor: widget.isBack ?? false
              ? Colors.grey.shade600
              : !(widget.isExit ?? false)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
