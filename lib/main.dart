import 'package:flutter/material.dart';

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

  // Placeholder for the Daily 5 checkboxes
  final List<bool> _dailyTasks = [false, false, false, false, false];
  final List<String> _taskLabels = [
    "Add 5 new prospects to my list",
    "Send 10 personalized messages",
    "Follow up with 3 people",
    "Share my business on social media",
    "Listen to 15 mins of personal development",
  ];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildHomeTab(),
      _buildTrackerTab(),
      _buildVaultTab(),
      _buildCrmTab(),
    ]);
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
        children: _pages,
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
                Text("You are on a 7-day streak! Keep pushing.", style: TextStyle(color: Colors.white.withOpacity(0.8))),
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
        _vaultCard("The Hook", "I'm looking for 3 people who want to fire their boss in 2026. If you want to see how I am building an extra income stream from my phone, comment 'INFO' below!"),
        _vaultCard("The Story", "3 months ago I was looking for a way out. Today, I am building a business that gives me time freedom. If you are tired of the 9-5, send me a DM."),
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
                  // Copy to clipboard logic will go here
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
