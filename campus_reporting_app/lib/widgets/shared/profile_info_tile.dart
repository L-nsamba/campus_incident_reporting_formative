import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: colors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: colors.primary),
        title: Text(title, style: Theme.of(context).textTheme.bodySmall),
        subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
