import 'package:flutter/material.dart';
import '../data/raid_data.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Map to store counts of each target item
  final Map<String, int> _targetCounts = {};
  String _selectedExplosiveMethod = 'Rocket'; // Default calculation method

  @override
  void initState() {
    super.initState();
    // Initialize counts
    for (var target in RaidData.targets) {
      _targetCounts[target.name] = 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for arguments passed from "AI Analysis"
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['ai_detected'] == true) {
      // Pre-fill data if not already filled (simple check to avoid overwriting on rebuilds)
      if (_targetCounts.values.every((v) => v == 0)) {
        setState(() {
          _targetCounts['Stone Wall'] = args['stone_walls'] ?? 0;
          _targetCounts['Sheet Metal Door'] = args['metal_doors'] ?? 0;
          _targetCounts['Garage Door'] = args['garage_doors'] ?? 0;
        });
        
        // Show a snackbar indicating AI success
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('AI Analysis Complete: Base structure estimated.'),
              backgroundColor: Color(0xFF738F3D),
            ),
          );
        });
      }
    }
  }

  void _increment(String key) {
    setState(() {
      _targetCounts[key] = (_targetCounts[key] ?? 0) + 1;
    });
  }

  void _decrement(String key) {
    setState(() {
      if ((_targetCounts[key] ?? 0) > 0) {
        _targetCounts[key] = (_targetCounts[key] ?? 0) - 1;
      }
    });
  }

  Map<String, int> _calculateTotalCost() {
    int totalSulfur = 0;
    int totalGunpowder = 0;
    int totalMetal = 0;
    int totalFuel = 0;
    
    // Also track total items needed (e.g., total Rockets)
    Map<String, int> explosiveCounts = {};

    _targetCounts.forEach((targetName, count) {
      if (count > 0) {
        final target = RaidData.targets.firstWhere((t) => t.name == targetName);
        
        // Get the cost for this target using the selected explosive method
        // If the method isn't valid for this target (unlikely with our data), fallback to C4
        int itemsPerTarget = target.explosiveCosts[_selectedExplosiveMethod] ?? 0;
        
        int totalItemsForThisTarget = itemsPerTarget * count;
        
        // Add to total explosive count
        explosiveCounts[_selectedExplosiveMethod] = (explosiveCounts[_selectedExplosiveMethod] ?? 0) + totalItemsForThisTarget;

        // Calculate raw material cost
        final explosive = RaidData.getExplosiveByName(_selectedExplosiveMethod);
        totalSulfur += explosive.sulfurCost * totalItemsForThisTarget;
        totalGunpowder += explosive.gunpowderCost * totalItemsForThisTarget;
        totalMetal += explosive.metalFragmentsCost * totalItemsForThisTarget;
        totalFuel += explosive.lowGradeFuelCost * totalItemsForThisTarget;
      }
    });

    return {
      'sulfur': totalSulfur,
      'gunpowder': totalGunpowder,
      'metal': totalMetal,
      'fuel': totalFuel,
      'item_count': explosiveCounts[_selectedExplosiveMethod] ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final costs = _calculateTotalCost();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RAID CALCULATOR'),
      ),
      body: Column(
        children: [
          // Results Header
          Container(
            color: const Color(0xFF2C2C2C),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Primary Explosive:', style: TextStyle(color: Colors.grey)),
                    DropdownButton<String>(
                      value: _selectedExplosiveMethod,
                      dropdownColor: const Color(0xFF3C3C3C),
                      underline: Container(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      items: RaidData.explosives.map((e) {
                        return DropdownMenuItem(value: e.name, child: Text(e.name));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedExplosiveMethod = val);
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCostItem('Sulfur', '${costs['sulfur']}', Icons.science, const Color(0xFFE6C200)),
                    _buildCostItem('Gunpowder', '${costs['gunpowder']}', Icons.grain, const Color(0xFF555555)),
                    _buildCostItem('Fuel', '${costs['fuel']}', Icons.local_gas_station, const Color(0xFFCE422B)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Total ${_selectedExplosiveMethod}s Needed: ${costs['item_count']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Target List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCategorySection('Walls', 'Wall'),
                _buildCategorySection('Doors', 'Door'),
                _buildCategorySection('Deployables', 'Deployable'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCategorySection(String title, String categoryFilter) {
    final items = RaidData.targets.where((t) => t.category == categoryFilter).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFCE422B),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        ...items.map((item) => _buildTargetRow(item)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTargetRow(RaidItem item) {
    int count = _targetCounts[item.name] ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: count > 0 ? const Color(0xFFCE422B) : Colors.transparent),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
            onPressed: () => _decrement(item.name),
          ),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFCE422B)),
            onPressed: () => _increment(item.name),
          ),
        ],
      ),
    );
  }
}
