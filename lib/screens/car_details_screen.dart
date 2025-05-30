import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/car_ad.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarAd carAd;
  CarDetailsScreen({required this.carAd});

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  late CarAd carAd;

  @override
  void initState() {
    super.initState();
    carAd = widget.carAd;
  }

  void toggleFavorite() async {
    setState(() {
      carAd.isFavorite = !carAd.isFavorite;
    });
    await DatabaseHelper.instance.updateCarAd(carAd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${carAd.brand} ${carAd.model}'),
        actions: [
          IconButton(
            icon: Icon(
              carAd.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(File(carAd.imagePath), width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${carAd.brand} ${carAd.model}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Cena: ${carAd.price} zł', style: TextStyle(fontSize: 18, color: Colors.green[700])),
                  SizedBox(height: 8),
                  Text('Rok produkcji: ${carAd.year}'),
                  Text('Pojemność silnika: ${carAd.engineCapacity}'),
                  Text('Przebieg: ${carAd.mileage} km'),
                  SizedBox(height: 16),
                  Text('Opis:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(carAd.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
