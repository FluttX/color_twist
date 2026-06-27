import 'package:color_twist/core/debug/developer_options.dart';
import 'package:flutter/material.dart';

class DeveloperOptionsSheet extends StatefulWidget {
  const DeveloperOptionsSheet({super.key});

  static Future<void> show(BuildContext context) {
    if (!DeveloperOptions.isAvailable) return Future.value();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const DeveloperOptionsSheet(),
    );
  }

  @override
  State<DeveloperOptionsSheet> createState() => _DeveloperOptionsSheetState();
}

class _DeveloperOptionsSheetState extends State<DeveloperOptionsSheet> {
  bool _unlockAll = DeveloperOptions.unlockAllStoreItems;

  Future<void> _setUnlockAll(bool value) async {
    await DeveloperOptions.setUnlockAllStoreItems(value);
    if (mounted) setState(() => _unlockAll = value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Developer Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Debug builds only — not included in release.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Unlock all store items'),
              subtitle: const Text(
                'Equip any skin, trail, theme, or music without spending coins.',
              ),
              value: _unlockAll,
              onChanged: _setUnlockAll,
            ),
          ],
        ),
      ),
    );
  }
}
