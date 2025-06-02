import 'package:flutter/material.dart';
import '../models/car_ad.dart';
import 'car_details_screen.dart';

class SuccessScreen extends StatelessWidget {
  final CarAd carAd;

  SuccessScreen({required this.carAd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ogłoszenie dodane!')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 16),
              Text(
                'Ogłoszenie zostało pomyślnie dodane!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailsScreen(carAd: carAd),
                    ),
                  );
                },
                child: Text(
                  'Zobacz ogłoszenie',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
