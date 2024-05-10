import 'package:flutter/material.dart';

class SdzButton extends StatefulWidget {
  final String text;
  final Future<void> Function()? onTap;
  final bool? isBack;
  final bool? isExit;

  const SdzButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isBack,
    this.isExit,
  });

  @override
  State<SdzButton> createState() => _SdzButtonState();
}

class _SdzButtonState extends State<SdzButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: widget.isBack ?? false
          ? const Icon(
              Icons.close,
              size: 16,
              weight: 500,
            )
          : !(widget.isExit ?? false)
              ? const Icon(Icons.check, size: 16)
              : const Icon(
                  Icons.logout,
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
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          backgroundColor: widget.isBack ?? false
              ? Theme.of(context).colorScheme.onBackground
              : !(widget.isExit ?? false)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(5))),
    );
  }
}
