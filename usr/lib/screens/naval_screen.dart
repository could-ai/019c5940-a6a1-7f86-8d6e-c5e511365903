import 'package:flutter/material.dart';

class NavalScreen extends StatefulWidget {
  const NavalScreen({super.key});

  @override
  State<NavalScreen> createState() => _NavalScreenState();
}

class _NavalScreenState extends State<NavalScreen> {
  double _targetHP = 1000;
  final double _cannonballDamage = 50; // Approximate damage per cannonball to structures/ships
  final int _cannonballSulfurCost = 30; // 15 GP (10 sulfur) + extra? Approx 30 sulfur total per ball logic

  @override
  Widget build(BuildContext context) {
    int ballsNeeded = (_targetHP / _cannonballDamage).ceil();
    int totalSulfur = ballsNeeded * _cannonballSulfurCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NAVAL COMBAT CALCULATOR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.directions_boat, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            Text(
              'SHIP DESTRUCTION CALCULATOR',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Calculate the number of cannonballs required to sink an enemy ship based on its estimated Health Points (HP).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            // HP Slider
            Text(
              'Target HP: ${_targetHP.toInt()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _targetHP,
              min: 100,
              max: 5000,
              divisions: 49,
              activeColor: const Color(0xFFCE422B),
              label: _targetHP.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _targetHP = value;
                });
              },
            ),
            
            const SizedBox(height: 40),
            
            // Results Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCE422B), width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'REQUIRED CANNONBALLS',
                    style: TextStyle(color: Colors.grey, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$ballsNeeded',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.science, color: Color(0xFFE6C200)),
                      const SizedBox(width: 8),
                      Text(
                        '$totalSulfur Sulfur Cost',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Info Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.blueGrey),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Note: Cannonballs deal reduced damage to land structures. This calculator is optimized for Naval/Ship combat.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
