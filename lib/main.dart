import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

// ------------------------------------------------------------
// IRRIGATION
// ------------------------------------------------------------

class IrrigationScreen extends StatefulWidget {
  const IrrigationScreen({super.key});

  @override
  State<IrrigationScreen> createState() => _IrrigationScreenState();
}

class _IrrigationScreenState extends State<IrrigationScreen> {
  // ==========================================================
  // DEMO SENSOR DATA
  // ==========================================================

  // Temporary values.
  // Later these will come from the ESP32/backend.

  double soilMoisture = 49.0;
  double temperature = 30.5;
  double humidity = 84.9;

  bool waterAvailable = true;
  bool rainDetected = false;

  // ==========================================================
  // IRRIGATION STATE
  // ==========================================================

  // false = AUTO
  // true  = MANUAL
  bool manualMode = false;

  // Motor state
  bool motorOn = false;

  // Rain lockout
  bool rainLockout = false;

  // Demo lockout time
  int lockoutSeconds = 0;

  // ==========================================================
  // MANUAL MODE TOGGLE
  // ==========================================================

  void changeManualMode(bool value) {
    setState(() {
      manualMode = value;

      // Motor always starts OFF when changing mode.
      motorOn = false;
    });
  }

  // ==========================================================
  // MOTOR TOGGLE
  // ==========================================================

  void changeMotorState(bool value) {
    // Motor can only be controlled in manual mode.
    if (!manualMode) {
      return;
    }

    // Rain protection
    if (rainDetected || rainLockout) {
      return;
    }

    // Water protection
    if (!waterAvailable) {
      return;
    }

    setState(() {
      motorOn = value;
    });
  }

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refreshData() async {
    // Temporary delay.
    //
    // Later:
    // GET /api/sensors/latest

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9F3),
        elevation: 0,

        title: const Text(
          'Irrigation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: refreshData,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            tooltip: 'Refresh',
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: refreshData,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            30,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // CURRENT STATUS
              // ==================================================

              _buildPumpStatus(),

              const SizedBox(height: 24),

              // ==================================================
              // CONTROLS
              // ==================================================

              const Text(
                'Irrigation Controls',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildControlCard(),

              const SizedBox(height: 24),

              // ==================================================
              // FIELD CONDITIONS
              // ==================================================

              const Text(
                'Field Conditions',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildSensorGrid(),

              const SizedBox(height: 24),

              // ==================================================
              // SAFETY & ENVIRONMENT
              // ==================================================

              const Text(
                'Safety & Environment',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Rain status
              _buildRainStatus(),

              const SizedBox(height: 10),

              // Rain lockout
              _buildLockoutStatus(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PUMP STATUS
  // ==========================================================

  Widget _buildPumpStatus() {
    final Color statusColor =
        motorOn
            ? Colors.blue
            : Colors.grey.shade600;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: motorOn
              ? [
                  Colors.blue.shade50,
                  Colors.white,
                ]
              : [
                  Colors.white,
                  Colors.grey.shade50,
                ],
        ),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: motorOn
                      ? Colors.blue.shade100
                      : Colors.grey.shade200,
                ),

                child: Icon(
                  Icons.water_drop_rounded,
                  size: 31,
                  color: statusColor,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Motor',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      motorOn
                          ? 'Running'
                          : 'Stopped',

                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(
                motorOn ? 'ON' : 'OFF',

                motorOn
                    ? Colors.blue
                    : Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),

            decoration: BoxDecoration(
              color: Colors.grey.shade100,

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Row(
              children: [
                Icon(
                  manualMode
                      ? Icons.touch_app_rounded
                      : Icons.auto_awesome_rounded,

                  size: 19,

                  color: manualMode
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
                ),

                const SizedBox(width: 8),

                Text(
                  manualMode
                      ? 'Manual control active'
                      : 'Automatic irrigation active',

                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CONTROL CARD
  // ==========================================================

  Widget _buildControlCard() {
    final bool motorControlAvailable =
        manualMode &&
        waterAvailable &&
        !rainDetected &&
        !rainLockout;

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          // --------------------------------------------------
          // MANUAL MODE
          // --------------------------------------------------

          Padding(
            padding: const EdgeInsets.fromLTRB(
              17,
              17,
              12,
              15,
            ),

            child: Row(
              children: [
                _controlIcon(
                  Icons.tune_rounded,
                  Colors.orange,
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Manual Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        manualMode
                            ? 'You control the motor'
                            : 'ESP32 controls irrigation',

                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Switch(
                  value: manualMode,
                  onChanged: changeManualMode,
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          // --------------------------------------------------
          // MOTOR
          // --------------------------------------------------

          Padding(
            padding: const EdgeInsets.fromLTRB(
              17,
              15,
              12,
              17,
            ),

            child: Row(
              children: [
                _controlIcon(
                  Icons.power_settings_new_rounded,

                  motorControlAvailable
                      ? Colors.blue
                      : Colors.grey,
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Motor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        !manualMode
                            ? 'Enable Manual Mode first'
                            : !waterAvailable
                                ? 'Water unavailable'
                                : rainDetected ||
                                        rainLockout
                                    ? 'Blocked by rain protection'
                                    : motorOn
                                        ? 'Motor is running'
                                        : 'Motor is stopped',

                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Switch(
                  value: motorOn,

                  onChanged:
                      motorControlAvailable
                          ? changeMotorState
                          : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SENSOR GRID
  // ==========================================================

  Widget _buildSensorGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _sensorCard(
                icon: Icons.grass_rounded,
                iconColor: Colors.green,
                title: 'Soil Moisture',

                value:
                    '${soilMoisture.toStringAsFixed(0)}%',

                subtitle:
                    soilMoisture < 30
                        ? 'Dry'
                        : soilMoisture < 60
                            ? 'Moderate'
                            : 'Moist',
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _sensorCard(
                icon: Icons.thermostat_rounded,
                iconColor: Colors.orange,
                title: 'Temperature',

                value:
                    '${temperature.toStringAsFixed(1)}°C',

                subtitle: 'Current',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _sensorCard(
                icon: Icons.water_rounded,
                iconColor: Colors.indigo,
                title: 'Humidity',

                value:
                    '${humidity.toStringAsFixed(1)}%',

                subtitle: 'Air humidity',
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _sensorCard(
                icon: Icons.water_drop_rounded,
                iconColor: Colors.blue,
                title: 'Water Supply',

                value: waterAvailable
                    ? 'Available'
                    : 'Unavailable',

                subtitle: 'Tank status',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // SENSOR CARD
  // ==========================================================

  Widget _sensorCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: iconColor.withValues(
                alpha: 0.12,
              ),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,

            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,

            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // RAIN STATUS
  // ==========================================================

  Widget _buildRainStatus() {
    return _environmentCard(
      icon: rainDetected
          ? Icons.umbrella_rounded
          : Icons.wb_sunny_rounded,

      iconColor: rainDetected
          ? Colors.blue
          : Colors.amber.shade700,

      title: 'Rain Status',

      value: rainDetected
          ? 'Rain detected'
          : 'No rain',

      description: rainDetected
          ? 'Irrigation is temporarily blocked'
          : 'Weather conditions are clear',
    );
  }

  // ==========================================================
  // RAIN LOCKOUT
  // ==========================================================

  Widget _buildLockoutStatus() {
    if (!rainLockout) {
      return _environmentCard(
        icon: Icons.lock_open_rounded,

        iconColor: Colors.green,

        title: 'Rain Lockout',

        value: 'Inactive',

        description:
            'No rain lockout is active',
      );
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.orange.shade50,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.orange.shade200,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.orange.shade100,
            ),

            child: Icon(
              Icons.lock_clock_rounded,
              color: Colors.orange.shade800,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Rain Lockout',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Active • '
                  '${_formatDuration(lockoutSeconds)} '
                  'remaining',

                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ENVIRONMENT CARD
  // ==========================================================

  Widget _environmentCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String description,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: iconColor.withValues(
                alpha: 0.12,
              ),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  description,

                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.check_circle_rounded,
            color: iconColor,
            size: 21,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CONTROL ICON
  // ==========================================================

  Widget _controlIcon(
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 44,
      height: 44,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: color.withValues(
          alpha: 0.12,
        ),
      ),

      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
    );
  }

  // ==========================================================
  // STATUS BADGE
  // ==========================================================

  Widget _statusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
        ),

        borderRadius:
            BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }

  // ==========================================================
  // FORMAT LOCKOUT TIME
  // ==========================================================

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;

    final int remainingSeconds =
        seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}


// ------------------------------------------------------------
// AI
// ------------------------------------------------------------

// ------------------------------------------------------------
// AI CROP DISEASE DETECTION
// ------------------------------------------------------------

// ------------------------------------------------------------
// AI CROP DISEASE DETECTION
// ------------------------------------------------------------

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  // ==========================================================
  // IMAGE
  // ==========================================================

  XFile? selectedImage;

  final ImagePicker _picker = ImagePicker();

  // ==========================================================
  // AI STATE
  // ==========================================================

  bool isAnalyzing = false;
  bool hasResult = false;

  // Temporary demo result.
  // Later these values will come from your AI model/API.
  String diseaseName = 'Healthy Paddy';
  double confidence = 0.94;

  // ==========================================================
  // TAKE PHOTO
  // ==========================================================

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      setState(() {
        selectedImage = image;
        hasResult = false;
      });
    } catch (e) {
      _showError(
        'Unable to open camera.\n$e',
      );
    }
  }

  // ==========================================================
  // UPLOAD FROM GALLERY
  // ==========================================================

  Future<void> uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      setState(() {
        selectedImage = image;
        hasResult = false;
      });
    } catch (e) {
      _showError(
        'Unable to select image.\n$e',
      );
    }
  }

  // ==========================================================
  // ANALYZE IMAGE
  // ==========================================================

  Future<void> analyzeImage() async {
    if (selectedImage == null) {
      _showError(
        'Please select or capture a crop image first.',
      );
      return;
    }

    setState(() {
      isAnalyzing = true;
      hasResult = false;
    });

    // ========================================================
    // TEMPORARY DEMO
    //
    // Later replace this section with:
    //
    // Flutter
    //    ↓
    // POST /disease/predict
    //    ↓
    // FastAPI
    //    ↓
    // InceptionV3 / your trained model
    //    ↓
    // prediction
    // ========================================================

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isAnalyzing = false;
      hasResult = true;

      diseaseName = 'Healthy Paddy';
      confidence = 0.94;
    });
  }

  // ==========================================================
  // RESET
  // ==========================================================

  void chooseAnotherImage() {
    setState(() {
      selectedImage = null;
      hasResult = false;
      isAnalyzing = false;
    });
  }

  // ==========================================================
  // ERROR MESSAGE
  // ==========================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9F3),
        elevation: 0,

        title: const Text(
          'AI Crop Doctor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          30,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ==================================================
            // INTRO
            // ==================================================

            _buildIntroCard(),

            const SizedBox(height: 22),

            const Text(
              'Crop Disease Detection',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // IMAGE
            // ==================================================

            _buildImageSection(),

            // ==================================================
            // ANALYZE
            // ==================================================

            if (selectedImage != null) ...[
              const SizedBox(height: 16),

              _buildAnalyzeButton(),
            ],

            // ==================================================
            // ANALYZING
            // ==================================================

            if (isAnalyzing) ...[
              const SizedBox(height: 18),

              _buildAnalyzingCard(),
            ],

            // ==================================================
            // RESULT
            // ==================================================

            if (hasResult) ...[
              const SizedBox(height: 24),

              const Text(
                'Detection Result',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildResultCard(),

              const SizedBox(height: 14),

              _buildRecommendationCard(),

              const SizedBox(height: 16),

              _buildAnotherImageButton(),
            ],

            // ==================================================
            // TIPS
            // ==================================================

            if (selectedImage == null) ...[
              const SizedBox(height: 24),

              _buildImageTips(),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // INTRO CARD
  // ==========================================================

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Colors.green.shade50,
            Colors.white,
          ],
        ),

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: Colors.green.shade100,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade100,
            ),

            child: Icon(
              Icons.eco_rounded,
              size: 30,
              color: Colors.green.shade700,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Check your crop health',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Take or upload a clear leaf photo '
                  'to detect possible crop diseases.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // IMAGE SECTION
  // ==========================================================

  Widget _buildImageSection() {
    // --------------------------------------------------------
    // NO IMAGE
    // --------------------------------------------------------

    if (selectedImage == null) {
      return Container(
        width: double.infinity,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(22),

          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),

        child: Column(
          children: [
            Container(
              width: 78,
              height: 78,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade50,
              ),

              child: Icon(
                Icons.add_a_photo_rounded,
                size: 38,
                color: Colors.green.shade700,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Add a photo of the crop leaf',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Use a clear, well-lit image',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                // CAMERA
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: takePhoto,

                    icon: const Icon(
                      Icons.camera_alt_rounded,
                    ),

                    label: const Text(
                      'Take Photo',
                    ),

                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      side: BorderSide(
                        color: Colors.green.shade300,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // GALLERY
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: uploadImage,

                    icon: const Icon(
                      Icons.photo_library_rounded,
                    ),

                    label: const Text(
                      'Upload',
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green.shade700,

                      foregroundColor:
                          Colors.white,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // --------------------------------------------------------
    // IMAGE SELECTED
    // --------------------------------------------------------

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(17),

            child: Image.file(
              File(selectedImage!.path),

              width: double.infinity,

              height: 250,

              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: Colors.green,
              ),

              const SizedBox(width: 7),

              const Expanded(
                child: Text(
                  'Image ready for analysis',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              TextButton(
                onPressed:
                    chooseAnotherImage,

                child: const Text(
                  'Change',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ANALYZE BUTTON
  // ==========================================================

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        onPressed:
            isAnalyzing
                ? null
                : analyzeImage,

        icon: Icon(
          isAnalyzing
              ? Icons.hourglass_top_rounded
              : Icons.auto_awesome_rounded,
        ),

        label: Text(
          isAnalyzing
              ? 'Analyzing...'
              : 'Analyze Crop',
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.green.shade700,

          foregroundColor:
              Colors.white,

          disabledBackgroundColor:
              Colors.grey.shade300,

          disabledForegroundColor:
              Colors.grey.shade600,

          padding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),

          elevation: 0,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ANALYZING
  // ==========================================================

  Widget _buildAnalyzingCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          const SizedBox(
            width: 35,
            height: 35,

            child:
                CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Analyzing your crop...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'AI is checking the leaf image',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // RESULT
  // ==========================================================

  Widget _buildResultCard() {
    final int confidencePercent =
        (confidence * 100).round();

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.green.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade100,
                ),

                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: Colors.green.shade700,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Detected condition',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      diseaseName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(
                'Healthy',
                Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Text(
                'AI Confidence',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              Text(
                '$confidencePercent%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),

            child:
                LinearProgressIndicator(
              value: confidence,

              minHeight: 8,

              backgroundColor:
                  Colors.grey.shade200,

              valueColor:
                  AlwaysStoppedAnimation<Color>(
                Colors.green.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // RECOMMENDATION
  // ==========================================================

  Widget _buildRecommendationCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade50,
                ),

                child: Icon(
                  Icons.lightbulb_rounded,
                  color: Colors.orange.shade700,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              const Text(
                'Recommendation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            'Your crop appears healthy. Continue '
            'regular monitoring and maintain proper '
            'irrigation and field conditions.',

            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Note: AI results are advisory. '
            'Confirm serious disease symptoms with '
            'an agricultural expert.',

            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ANOTHER IMAGE
  // ==========================================================

  Widget _buildAnotherImageButton() {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton.icon(
        onPressed:
            chooseAnotherImage,

        icon: const Icon(
          Icons.add_a_photo_rounded,
        ),

        label: const Text(
          'Analyze Another Image',
        ),

        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(
            vertical: 14,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // IMAGE TIPS
  // ==========================================================

  Widget _buildImageTips() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'For better detection',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _tipRow(
            Icons.wb_sunny_rounded,
            'Use good natural lighting',
          ),

          _tipRow(
            Icons.center_focus_strong_rounded,
            'Keep the leaf clearly visible',
          ),

          _tipRow(
            Icons.image_rounded,
            'Avoid blurry or dark photos',
          ),

          _tipRow(
            Icons.crop_free_rounded,
            'Capture the affected area closely',
          ),
        ],
      ),
    );
  }

  Widget _tipRow(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 9),

      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: Colors.green.shade700,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              text,

              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STATUS BADGE
  // ==========================================================

  Widget _statusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
        ),

        borderRadius:
            BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: color,
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// FARM
// ------------------------------------------------------------

// ------------------------------------------------------------
// FARM MANAGEMENT
// ------------------------------------------------------------

class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  // ==========================================================
  // DEMO FARM DATA
  // ==========================================================

  // Later these values will come from the database.

  String cropName = 'Paddy';
  String variety = 'BPT 5204';

  int cropAge = 68;
  String growthStage = 'Vegetative';

  // Overall crop health.
  double cropHealth = 87;

  // Soil data
  double soilMoisture = 49;
  double averageTemperature = 29.4;

  // ==========================================================
  // IRRIGATION DATA
  // ==========================================================

  int irrigationCount = 18;

  // Total time the crop has been irrigated.
  int irrigationDuration = 42;

  String lastIrrigation = 'Today, 7:30 AM';

  // ==========================================================
  // DISEASE DATA
  // ==========================================================

  int diseasesDetected = 1;
  int diseasesTreated = 1;

  String lastDisease = 'Leaf Blast';
  String diseaseStatus = 'Treated';

  // ==========================================================
  // REFRESH
  // ==========================================================

  Future<void> refreshFarmData() async {
    // Temporary delay.
    //
    // Later:
    //
    // GET /api/crop/summary
    // GET /api/irrigation/history
    // GET /api/disease/history

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {});
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9F3),
        elevation: 0,

        title: const Text(
          'Farm Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: refreshFarmData,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            tooltip: 'Refresh',
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: refreshFarmData,

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            16,
            6,
            16,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ==================================================
              // CROP OVERVIEW
              // ==================================================

              _buildCropOverview(),

              const SizedBox(height: 22),

              // ==================================================
              // CROP HEALTH
              // ==================================================

              const Text(
                'Crop Health',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildHealthCard(),

              const SizedBox(height: 22),

              // ==================================================
              // FIELD DATA
              // ==================================================

              const Text(
                'Field Overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildFieldOverview(),

              const SizedBox(height: 22),

              // ==================================================
              // IRRIGATION SUMMARY
              // ==================================================

              const Text(
                'Irrigation Summary',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildIrrigationSummary(),

              const SizedBox(height: 22),

              // ==================================================
              // DISEASE SUMMARY
              // ==================================================

              const Text(
                'Disease & Treatment',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildDiseaseSummary(),

              const SizedBox(height: 22),

              // ==================================================
              // RECENT ACTIVITY
              // ==================================================

              const Text(
                'Recent Farm Activity',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _buildActivityTimeline(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CROP OVERVIEW
  // ==========================================================

  Widget _buildCropOverview() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Colors.green.shade700,
            Colors.green.shade500,
          ],
        ),

        borderRadius:
            BorderRadius.circular(25),
      ),

      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.white.withValues(
                alpha: 0.18,
              ),
            ),

            child: const Icon(
              Icons.grass_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  cropName,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Variety: $variety',

                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: 0.85),

                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '$cropAge days • $growthStage stage',

                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: 0.85),

                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HEALTH CARD
  // ==========================================================

  Widget _buildHealthCard() {
    Color healthColor;

    if (cropHealth >= 80) {
      healthColor = Colors.green;
    } else if (cropHealth >= 60) {
      healthColor = Colors.orange;
    } else {
      healthColor = Colors.red;
    }

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: healthColor.withValues(
                    alpha: 0.12,
                  ),
                ),

                child: Icon(
                  Icons.favorite_rounded,
                  color: healthColor,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Overall Crop Health',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      cropHealth >= 80
                          ? 'Healthy'
                          : cropHealth >= 60
                              ? 'Needs attention'
                              : 'At risk',

                      style: TextStyle(
                        fontSize: 12,
                        color: healthColor,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${cropHealth.toStringAsFixed(0)}%',

                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: healthColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: cropHealth / 100,

              minHeight: 9,

              backgroundColor:
                  Colors.grey.shade200,

              valueColor:
                  AlwaysStoppedAnimation<Color>(
                healthColor,
              ),
            ),
          ),

          const SizedBox(height: 13),

          Text(
            'Health score is calculated from field '
            'conditions, irrigation activity and '
            'disease history.',

            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FIELD OVERVIEW
  // ==========================================================

  Widget _buildFieldOverview() {
    return Row(
      children: [
        Expanded(
          child: _dataCard(
            icon: Icons.water_drop_rounded,
            iconColor: Colors.blue,
            title: 'Soil Moisture',
            value:
                '${soilMoisture.toStringAsFixed(0)}%',
            subtitle: 'Current',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _dataCard(
            icon: Icons.thermostat_rounded,
            iconColor: Colors.orange,
            title: 'Avg. Temperature',
            value:
                '${averageTemperature.toStringAsFixed(1)}°C',
            subtitle: 'Recent average',
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // IRRIGATION SUMMARY
  // ==========================================================

  Widget _buildIrrigationSummary() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              _summaryIcon(
                Icons.water_drop_rounded,
                Colors.blue,
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Irrigation Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _miniStat(
                  '$irrigationCount',
                  'Irrigations',
                  Icons.water_rounded,
                ),
              ),

              Expanded(
                child: _miniStat(
                  '$irrigationDuration min',
                  'Irrigation time',
                  Icons.timer_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),

            decoration: BoxDecoration(
              color: Colors.blue.shade50,

              borderRadius:
                  BorderRadius.circular(13),
            ),

            child: Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: Colors.blue.shade700,
                ),

                const SizedBox(width: 8),

                Text(
                  'Last irrigation: $lastIrrigation',

                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DISEASE SUMMARY
  // ==========================================================

  Widget _buildDiseaseSummary() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              _summaryIcon(
                Icons.health_and_safety_rounded,
                Colors.green,
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Disease History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              _statusBadge(
                diseasesDetected == 0
                    ? 'No issues'
                    : 'Monitored',

                diseasesDetected == 0
                    ? Colors.green
                    : Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _miniStat(
                  '$diseasesDetected',
                  'Detected',
                  Icons.search_rounded,
                ),
              ),

              Expanded(
                child: _miniStat(
                  '$diseasesTreated',
                  'Treated',
                  Icons.medical_services_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (diseasesDetected > 0)
            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(13),

              decoration: BoxDecoration(
                color: Colors.orange.shade50,

                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color:
                        Colors.orange.shade700,
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Text(
                          lastDisease,
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Status: $diseaseStatus',
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              'No disease has been recorded.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // ACTIVITY TIMELINE
  // ==========================================================

  Widget _buildActivityTimeline() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        children: [
          _activityItem(
            icon: Icons.water_drop_rounded,
            iconColor: Colors.blue,
            title: 'Irrigation completed',
            subtitle:
                'Motor operated automatically',
            time: 'Today, 7:30 AM',
            isLast: false,
          ),

          _activityItem(
            icon: Icons.health_and_safety_rounded,
            iconColor: Colors.green,
            title: 'Disease treatment recorded',
            subtitle:
                '$lastDisease marked as treated',
            time: 'Yesterday, 5:20 PM',
            isLast: false,
          ),

          _activityItem(
            icon: Icons.eco_rounded,
            iconColor: Colors.green,
            title: 'Crop health updated',
            subtitle:
                'Health score: '
                '${cropHealth.toStringAsFixed(0)}%',
            time: 'Yesterday, 8:00 AM',
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DATA CARD
  // ==========================================================

  Widget _dataCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: iconColor.withValues(
                alpha: 0.12,
              ),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,

            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,

            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SUMMARY ICON
  // ==========================================================

  Widget _summaryIcon(
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 43,
      height: 43,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: color.withValues(
          alpha: 0.12,
        ),
      ),

      child: Icon(
        icon,
        color: color,
        size: 23,
      ),
    );
  }

  // ==========================================================
  // MINI STAT
  // ==========================================================

  Widget _miniStat(
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 21,
          color: Colors.grey.shade600,
        ),

        const SizedBox(height: 6),

        Text(
          value,

          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,

          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // ACTIVITY ITEM
  // ==========================================================

  Widget _activityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: iconColor.withValues(
                  alpha: 0.12,
                ),
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: 21,
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 42,

                color: Colors.grey.shade200,
              ),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(
              top: 2,
              bottom: 18,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  time,

                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // STATUS BADGE
  // ==========================================================

  Widget _statusBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
        ),

        borderRadius:
            BorderRadius.circular(30),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          color: color,
        ),
      ),
    );
  }
}