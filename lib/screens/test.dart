import 'package:flutter/material.dart';
import 'dart:ui'; // For the BackdropFilter widget

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            elevation: 5, // Shadow for the card
            child: InkWell(
              onTap: () {
                // Action when the card is tapped
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Background blur effect using BackdropFilter
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Blur effect
                        child: Container(
                          color: Colors.black.withOpacity(0), // Transparent background
                        ),
                      ),
                    ),
                    // Card content with a slightly transparent background
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1), // Slight transparency
                        borderRadius: BorderRadius.circular(16), // Rounded corners
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Column for Text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Title Here', // Replace 'tll' with actual title
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // White text for contrast
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Ready...',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white.withOpacity(0.7), // Slightly faded text
                                ),
                              ),
                            ],
                          ),
                          // Arrow icon on the right side
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 18.0,
                            color: Colors.white, // White icon for contrast
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
