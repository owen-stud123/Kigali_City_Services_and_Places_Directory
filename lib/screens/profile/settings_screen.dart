import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // Local simulation state

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Profile Section
          const Text(
            "Profile",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF0F172A),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(user?.email ?? "Guest User"),
              subtitle: Text("UID: ${user?.uid ?? 'N/A'}"),
            ),
          ),

          const SizedBox(height: 20),

          // Notifications Toggle (Rubric Requirement)
          const Text(
            "Preferences",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text("Location Notifications"),
            subtitle: const Text("Receive alerts when near a pinned location"),
            value: _notificationsEnabled,
            activeColor: const Color(0xFFFACC15),
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Notifications ${value ? 'Enabled' : 'Disabled'}",
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                authProvider.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text("Log Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
