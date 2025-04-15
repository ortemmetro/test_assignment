import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget implements PreferredSizeWidget {
  const BottomSheetHeader({
    required this.isSelecting,
    required this.selectText,
    super.key,
    this.onSelectTap,
  });

  final String selectText;
  final bool isSelecting;
  final void Function()? onSelectTap;

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 6,
              width: 40,
              decoration: const ShapeDecoration(
                color: Colors.black12,
                shape: StadiumBorder(),
              ),
            ),
            const SizedBox(height: 16),
            isSelecting
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(selectText, style: const TextStyle(fontSize: 20)),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onSelectTap,
                          child: const Text('Select'),
                        ),
                      ),
                    ],
                  ),
                )
                : Expanded(
                  child: Center(
                    child: Text(
                      'Book a ride',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(fontSize: 20),
                    ),
                  ),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
