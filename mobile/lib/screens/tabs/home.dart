import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:switcher_button/switcher_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool status = true; // Initial state of the switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20), // Add spacing between elements
          SizedBox(
            width: 200,
            height: 250, // Decreased height of the tank
            child: LiquidCustomProgressIndicator(
              value: 0.9, // Static 90% fill (or adjust as needed)
              valueColor: const AlwaysStoppedAnimation(Colors.lightBlue),
              backgroundColor: Colors.grey[300],
              direction: Axis.vertical,
              center: const Text(
                '50%',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              shapePath: _buildTankPath(),
            ),
          ),
          const SizedBox(height: 20), // Add spacing between the elements
          SwitcherButton(
            value: status,
            onChange: (value) {
              setState(() {
                status = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Text(
            status ? "ON" : "OFF",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Path _buildTankPath() {
    return Path()
      // Top of the tank with curved edges
      ..moveTo(40, 0) // Start at the top-left corner
      ..lineTo(160, 0) // Top edge goes straight to the right
      ..arcToPoint(
        const Offset(170, 10), // Curved right edge
        radius: const Radius.circular(10),
        clockwise: false,
      )
      ..lineTo(30, 10) // Line to the left side of the top
      ..arcToPoint(
        const Offset(40, 0), // Curved left edge, closing the top
        radius: const Radius.circular(10),
        clockwise: false,
      )

      // Body of the tank (vertical sides)
      ..moveTo(40, 10) // Starting from the top-left corner
      ..lineTo(160, 10) // Line across the top
      ..lineTo(160, 160) // Down the right side (reduced height)
      ..lineTo(40, 160) // Bottom-left corner (reduced height)
      ..lineTo(40, 10) // Back up the left side
      ..close(); // Complete the path
  }
}
