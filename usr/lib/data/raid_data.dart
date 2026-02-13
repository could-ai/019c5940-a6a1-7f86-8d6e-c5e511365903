class RaidItem {
  final String name;
  final String category; // Wall, Door, Deployable
  final int hp;
  final Map<String, int> explosiveCosts; // Map of ExplosiveType -> Count

  const RaidItem({
    required this.name,
    required this.category,
    required this.hp,
    required this.explosiveCosts,
  });
}

class Explosive {
  final String name;
  final int sulfurCost;
  final int gunpowderCost;
  final int metalFragmentsCost;
  final int lowGradeFuelCost;
  final int damage; // Approximate damage to structures

  const Explosive({
    required this.name,
    required this.sulfurCost,
    required this.gunpowderCost,
    required this.metalFragmentsCost,
    required this.lowGradeFuelCost,
    required this.damage,
  });
}

class RaidData {
  // Explosive Definitions
  static const List<Explosive> explosives = [
    Explosive(name: 'Rocket', sulfurCost: 1400, gunpowderCost: 650, metalFragmentsCost: 100, lowGradeFuelCost: 30, damage: 350),
    Explosive(name: 'C4', sulfurCost: 2200, gunpowderCost: 1000, metalFragmentsCost: 200, lowGradeFuelCost: 60, damage: 550), // High explosive C4
    Explosive(name: 'Satchel Charge', sulfurCost: 480, gunpowderCost: 240, metalFragmentsCost: 80, lowGradeFuelCost: 0, damage: 75), // 4 Beancans + Stash
    Explosive(name: 'Beancan Grenade', sulfurCost: 120, gunpowderCost: 60, metalFragmentsCost: 20, lowGradeFuelCost: 0, damage: 18),
    Explosive(name: 'Explosive Ammo', sulfurCost: 25, gunpowderCost: 20, metalFragmentsCost: 10, lowGradeFuelCost: 0, damage: 1), // Per bullet roughly
  ];

  // Target Definitions (Simplified costs for demo)
  static const List<RaidItem> targets = [
    // Walls
    RaidItem(name: 'Wood Wall', category: 'Wall', hp: 250, explosiveCosts: {'Rocket': 2, 'C4': 1, 'Satchel Charge': 3, 'Beancan Grenade': 13, 'Explosive Ammo': 49}),
    RaidItem(name: 'Stone Wall', category: 'Wall', hp: 500, explosiveCosts: {'Rocket': 4, 'C4': 2, 'Satchel Charge': 10, 'Beancan Grenade': 46, 'Explosive Ammo': 185}),
    RaidItem(name: 'Metal Wall', category: 'Wall', hp: 1000, explosiveCosts: {'Rocket': 8, 'C4': 4, 'Satchel Charge': 23, 'Beancan Grenade': 112, 'Explosive Ammo': 400}),
    RaidItem(name: 'Armored Wall', category: 'Wall', hp: 2000, explosiveCosts: {'Rocket': 15, 'C4': 8, 'Satchel Charge': 46, 'Beancan Grenade': 224, 'Explosive Ammo': 799}),
    
    // Doors
    RaidItem(name: 'Wood Door', category: 'Door', hp: 200, explosiveCosts: {'Rocket': 1, 'C4': 1, 'Satchel Charge': 2, 'Beancan Grenade': 6, 'Explosive Ammo': 18}),
    RaidItem(name: 'Sheet Metal Door', category: 'Door', hp: 250, explosiveCosts: {'Rocket': 2, 'C4': 1, 'Satchel Charge': 4, 'Beancan Grenade': 18, 'Explosive Ammo': 63}),
    RaidItem(name: 'Garage Door', category: 'Door', hp: 600, explosiveCosts: {'Rocket': 3, 'C4': 2, 'Satchel Charge': 9, 'Beancan Grenade': 42, 'Explosive Ammo': 150}),
    RaidItem(name: 'Armored Door', category: 'Door', hp: 800, explosiveCosts: {'Rocket': 5, 'C4': 3, 'Satchel Charge': 15, 'Beancan Grenade': 56, 'Explosive Ammo': 250}), // Often 2 C4 + rockets, simplified here
    
    // Deployables
    RaidItem(name: 'Auto Turret', category: 'Deployable', hp: 1000, explosiveCosts: {'Rocket': 4, 'C4': 1, 'Satchel Charge': 3, 'Beancan Grenade': 12, 'Explosive Ammo': 100}), // High velocity rockets often used, but standard rockets listed
    RaidItem(name: 'High External Stone Wall', category: 'Deployable', hp: 500, explosiveCosts: {'Rocket': 4, 'C4': 2, 'Satchel Charge': 10, 'Beancan Grenade': 46, 'Explosive Ammo': 185}),
  ];

  static Explosive getExplosiveByName(String name) {
    return explosives.firstWhere((e) => e.name == name, orElse: () => explosives.first);
  }
}
