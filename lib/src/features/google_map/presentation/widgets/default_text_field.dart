import 'package:flutter/material.dart';

class DefaultTextField extends StatefulWidget {
  const DefaultTextField({
    required this.hintText,
    this.prefix,
    super.key,
    this.onTap,
    this.keyboardType,
    this.readOnly = false,
    this.controller,
  });

  final String hintText;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final bool readOnly;
  final void Function()? onTap;
  final TextEditingController? controller;

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late final TextEditingController? _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        prefixIcon: widget.prefix,
      ),
    );
  }
}
