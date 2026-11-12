import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const IgiowoApp());
}

class IgiowoApp extends StatelessWidget {
  const IgiowoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Igiowo Diamond',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37), // Gold
          brightness: Brightness.dark,
          primary: const Color(0xFFD4AF37),
          secondary: const Color(0xFF1E3A8A), // Deep Blue
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark Navy
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          elevation: 0,
        ),
      ),
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  // ✅ THE NEW WEB APP URL IS HERE
  final String scriptUrl = 'https://script.google.com/macros/s/AKfycbyr8IXG0OubSPi8y3OiHuMK8PBUjJbGnkBbf5UDh4Z_DWAeC7lINDqGIirKqXhkMMPi/exec';

  // Placeholder for the Daily 5 checkboxes
  final List<bool> _dailyTasks = [false, false, false, false, false];
  final List<String> _taskLabels = [
    "Add 5 new prospects to my list",
    "Send 10 personalized messages",
    "Follow up with 3 people",
    "Share my business on social media",
    "Listen to 15 mins of personal development",
  ];

  List<Map<String, dynamic>> _vaultItems = [];
  bool _isLoadingVault = true;

  @override
  void initState() {
    super.initState();
    _fetchVaultItems();
  }

  // Fetch Traffic Vault from Google Sheets
  Future<void> _fetchVaultItems() async {
    try {
      final response = await http.get(Uri.parse('$scriptUrl?action=get_vault'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _vaultItems = List<Map<String, dynamic>>.from(data['items']);
            _isLoadingVault = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingVault = false;
      });
      print("Error fetching vault: $e");
    }
  }

  // Send Daily 5 log to Google Sheets
  Future<void> _submitDailyLog() async {
    final Map<String, String> body = {
      'type': 'daily_log',
      'contacts': _dailyTasks[0].toString(),
      'messages': _dailyTasks[1].toString(),
      'followups': _dailyTasks[2].toString(),
      'posts': _dailyTasks[3].toString(),
      'training': _dailyTasks[4].toString(),
    };

    try {
      await http.post(Uri.parse(scriptUrl), body: body);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily log saved to database! 🚀'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.diamond, color: Color(0xFFD4AF37), size: 20),
            const SizedBox(width: 8),
            Text(
              'IGIOWO DIAMOND',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildTrackerTab(),
          _buildVaultTab(),
          _buildCrmTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.check_circle_outline), selectedIcon: Icon(Icons.check_circle), label: 'Daily 5'),
          NavigationDestination(icon: Icon(Icons.send_outlined), selectedIcon: Icon(Icons.send), label: 'Traffic'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'CRM'),
        ],
      ),
    );
  }

  // --- TABS ---

  Widget _buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF1E3A8A),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Welcome back, Leader.", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text("Consistency creates Diamonds. Keep pushing.", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statBox("Focus", "Daily 5"),
                    _statBox("Prospects", "12"),
                    _statBox("Rank", "Bronze"),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text("My 'Why'", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: const Text(
            "\"I am building this business to create financial freedom for my family and to help others achieve their dreams. I will not quit.\"",
            style: TextStyle(fontStyle: FontStyle.italic, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _statBox(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTrackerTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("The Daily 5", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
        const SizedBox(height: 8),
        const Text("Success is a daily habit. Check off your tasks.", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        ...List.generate(5, (index) {
          return Card(
            color: Colors.white.withOpacity(0.05),
            child: CheckboxListTile(
              title: Text(_taskLabels[index], style: TextStyle(color: _dailyTasks[index] ? Colors.grey : Colors.white)),
              value: _dailyTasks[index],
              onChanged: (bool? value) {
                setState(() {
                  _dailyTasks[index] = value ?? false;
                });
              },
              activeColor: const Color(0xFFD4AF37),
              checkColor: Colors.black,
            ),
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitDailyLog,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("Save Daily Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        )
      ],
    );
  }

  Widget _buildVaultTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Smart Traffic Vault", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
        const SizedBox(height: 8),
        const Text("Tap to copy and share on social media.", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        if (_isLoadingVault)
          const Center(child: CircularProgressIndicator())
        else if (_vaultItems.isEmpty)
          const Text("No messages in the vault yet. Add some to your Google Sheet!")
        else
          ..._vaultItems.map((item) => _vaultCard(item['title'], item['text'])),
      ],
    );
  }

  Widget _vaultCard(String title, String text) {
    return Card(
      color: const Color(0xFF1E3A8A),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
            const SizedBox(height: 10),
            Text(text, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Copy logic would go here
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text("Copy & Share"),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCrmTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("My Prospects", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
        const SizedBox(height: 8),
        const Text("Never lose track of a follow-up again.", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        ListTile(
          tileColor: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: const CircleAvatar(backgroundColor: Color(0xFF1E3A8A), child: Icon(Icons.person, color: Colors.white)),
          title: const Text("John Doe"),
          subtitle: const Text("Status: Watched Presentation"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        )
      ],
    );
  }
}
