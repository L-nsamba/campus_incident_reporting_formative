import 'package:campus_reporting_app/providers/auth_provider.dart';
import 'package:campus_reporting_app/providers/theme_provider.dart';
import 'package:campus_reporting_app/widgets/shared/profile_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    final user = authProvider.appUser;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final initials = user.name.trim().isEmpty
        ? '?'
        : user.name.trim().substring(0, 1).toUpperCase();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Profile Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: colors.primaryContainer,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Name
            Text(
              user.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Role
            Text(
              authProvider.isStaff ? 'Staff Account' : 'Student Account',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 30),

            // Account information
            ProfileInfoTile(
              icon: Icons.person_outline,
              title: 'Full Name',
              value: user.name,
            ),

            ProfileInfoTile(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: user.email,
            ),

            ProfileInfoTile(
              icon: Icons.badge_outlined,
              title: 'Account Role',
              value: authProvider.isStaff ? 'Staff' : 'Student',
            ),

            const SizedBox(height: 24),

            // Appearance settings
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferences',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: colors.surface,
              child: SwitchListTile(
                secondary: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                title: const Text('Dark Mode'),
                subtitle: const Text('Change the appearance of the app'),
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ),

            const SizedBox(height: 30),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.error,
                  side: BorderSide(color: colors.error),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text(
            'Are you sure you want to log our of your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
    if (shouldLogout == true && context.mounted) {
      await context.read<AuthProvider>().logout();

      // Authgate listens to firebase authentication stream and will auto display login screen upon logout
    }
  }
}
