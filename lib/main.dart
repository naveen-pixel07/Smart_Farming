import 'package:flutter/material.dart';

void main() {
  runApp(const SmartAgricultureApp());
}

class SmartAgricultureApp extends StatelessWidget {
  const SmartAgricultureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Agriculture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    DashboardScreen(),
    IrrigationScreen(),
    AIScreen(),
    FarmScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Irrigation',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.agriculture_outlined),
            selectedIcon: Icon(Icons.agriculture),
            label: 'Farm',
          ),
        ],
      ),
    );
  }
}


// ------------------------------------------------------------
// DASHBOARD
// ------------------------------------------------------------

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Agriculture'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Farm Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Monitor your farm in real time',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 24),

            // Sensor cards
            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'Temperature',
                    value: '28°C',
                    icon: Icons.thermostat,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SensorCard(
                    title: 'Humidity',
                    value: '72%',
                    icon: Icons.water,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: SensorCard(
                    title: 'Soil Moisture',
                    value: '64%',
                    icon: Icons.grass,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SensorCard(
                    title: 'Water Level',
                    value: '82%',
                    icon: Icons.water_drop,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Irrigation status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.water_drop,
                      size: 40,
                      color: Colors.blue,
                    ),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Irrigation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'Pump is currently OFF',
                          ),
                        ],
                      ),
                    ),

                    Switch(
                      value: false,
                      onChanged: null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Crop health
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.eco),
                ),

                title: const Text(
                  'Crop Health',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  'No disease detected',
                ),

                trailing: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ------------------------------------------------------------
// SENSOR CARD
// ------------------------------------------------------------

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Icon(
              icon,
              size: 32,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ------------------------------------------------------------
// IRRIGATION
// ------------------------------------------------------------

class IrrigationScreen extends StatelessWidget {
  const IrrigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation'),
      ),

      body: const Center(
        child: Text(
          'Irrigation Module',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// ------------------------------------------------------------
// AI
// ------------------------------------------------------------

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI'),
      ),

      body: const Center(
        child: Text(
          'AI Crop Management',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// ------------------------------------------------------------
// FARM
// ------------------------------------------------------------

class FarmScreen extends StatelessWidget {
  const FarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm'),
      ),

      body: const Center(
        child: Text(
          'Farm Management',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}