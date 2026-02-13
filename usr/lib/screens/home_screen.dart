import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _uploadedImages = [];
  bool _isAnalyzing = false;

  // Pre-defined mock images for simulation
  final List<String> _mockImages = [
    'https://rustlabs.com/img/items180/wall.frame.garagedoor.png',
    'https://rustlabs.com/img/items180/wall.external.high.stone.png',
    'https://rustlabs.com/img/items180/door.hinged.metal.png',
    'https://rustlabs.com/img/items180/wall.window.glass.reinforced.png',
  ];

  void _showAddImageOptions() {
    if (_uploadedImages.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 4 images allowed.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFCE422B)),
                title: const Text('Take Photo (Simulated)', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _addMockImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFCE422B)),
                title: const Text('Choose from Gallery (Simulated)', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _addMockImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.link, color: Color(0xFFCE422B)),
                title: const Text('Paste Image URL', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showUrlInputDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addMockImage() {
    setState(() {
      // Cycle through mock images or use a generic placeholder
      int index = _uploadedImages.length % _mockImages.length;
      _uploadedImages.add(_mockImages[index]);
    });
  }

  void _showUrlInputDialog() {
    final TextEditingController urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text('Paste Image URL', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: urlController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'https://example.com/image.jpg',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFCE422B))),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (urlController.text.isNotEmpty) {
                  setState(() {
                    _uploadedImages.add(urlController.text);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add', style: TextStyle(color: Color(0xFFCE422B))),
            ),
          ],
        );
      },
    );
  }

  void _clearImages() {
    setState(() {
      _uploadedImages.clear();
    });
  }

  void _analyzeBase() async {
    if (_uploadedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image of the base.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI Analysis Delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isAnalyzing = false;
    });

    // Navigate to Calculator with "Pre-filled" data from "AI"
    Navigator.pushNamed(context, '/calculator', arguments: {
      'ai_detected': true,
      'stone_walls': 4,
      'metal_doors': 2,
      'garage_doors': 1,
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _uploadedImages.length / 4.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RUST RAID CALCULATOR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.anchor),
            onPressed: () => Navigator.pushNamed(context, '/naval'),
            tooltip: 'Naval Calculator',
          ),
        ],
      ),
      floatingActionButton: _uploadedImages.length < 4
          ? FloatingActionButton.extended(
              onPressed: _showAddImageOptions,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Add Photo'),
              backgroundColor: const Color(0xFFCE422B),
              foregroundColor: Colors.white,
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildUploadSection(progress),
            const SizedBox(height: 30),
            _buildActionButtons(),
            const SizedBox(height: 40),
            _buildFeaturesList(),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(Icons.security, size: 80, color: Color(0xFFCE422B)),
        const SizedBox(height: 16),
        Text(
          'AI BASE ANALYZER',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload 3-4 screenshots of a base to estimate raid costs using deductive reasoning.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[400], fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildUploadSection(double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upload Progress',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (_uploadedImages.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearImages,
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                  label: const Text('Clear', style: TextStyle(color: Colors.grey)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            color: const Color(0xFFCE422B),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_uploadedImages.length}/4 Images',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              if (index < _uploadedImages.length) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(_uploadedImages[index]),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            // Fallback if image fails to load
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 16, color: Colors.green),
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: _showAddImageOptions,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[700]!, style: BorderStyle.dashed),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline, color: Colors.grey, size: 30),
                        SizedBox(height: 8),
                        Text('Tap to Add', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _isAnalyzing ? null : _analyzeBase,
          icon: _isAnalyzing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.analytics),
          label: Text(_isAnalyzing ? 'ANALYZING BASE...' : 'ANALYZE BASE IMAGES'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/calculator'),
          icon: const Icon(Icons.calculate),
          label: const Text('MANUAL CALCULATOR'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FEATURES',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        _buildFeatureItem(Icons.auto_awesome, 'AI Deductive Reasoning', 'Estimates weak points from images.'),
        _buildFeatureItem(Icons.science, 'Sulfur Calculation', 'Exact sulfur & charcoal requirements.'),
        _buildFeatureItem(Icons.directions_boat, 'Naval Combat', 'Cannonball calculator for ship battles.'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFCE422B)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
