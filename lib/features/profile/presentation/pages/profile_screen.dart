import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_delivery_mobile/config/routes/routes_constants.dart';
import 'package:pos_delivery_mobile/features/auth/presentation/bloc/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                if (state is AuthAuthenticated) ...[
                  Text(
                    state.user.username ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.user.userId ?? 'ID not available',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Profile'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                const SizedBox(height: 8),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                const SizedBox(height: 8),
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notification Settings'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().logout();
                context.go(Routes.login);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: false,
                  onChanged: null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.language),
                title: Text('Language'),
                subtitle: Text('English'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.storage),
                title: Text('Clear Cache'),
                subtitle: Text('Free up storage space'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                subtitle: Text('App version and info'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Support'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy Policy'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().logout();
                context.go(Routes.login);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}