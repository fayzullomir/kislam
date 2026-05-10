import 'package:flutter/material.dart';

import 'noor_tokens.dart';

/// Top bar used by Home / Learn / Q&A screens with the wordmark title
/// and a bell icon on the right.
class IslamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final List<Widget> trailing;
  final bool showTitle;

  const IslamicAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.trailing = const [],
    this.showTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.noor.neutral,
      elevation: 0,
      toolbarHeight: 64,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: showTitle
                ? Text(
                    title,
                    style: TextStyle(
                      color: context.noor.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          ...trailing,
          _IconButton(
            icon: Icons.notifications_none_rounded,
            onTap: onNotificationTap,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: context.noor.primary,
            size: 26,
          ),
        ),
      ),
    );
  }
}
