import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/car_ad.dart';
import '../models/car_image.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarAd carAd;
  CarDetailsScreen({required this.carAd});

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  late CarAd carAd;
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    carAd = widget.carAd;
    _loadImages();
  }

  Future<void> _loadImages() async {
    final images = await DatabaseHelper.instance.getCarImages(carAd.id!);
    setState(() {
      imagePaths = images.map((img) => img.imagePath).toList();
    });
  }

  void toggleFavorite() async {
    setState(() {
      carAd.isFavorite = !carAd.isFavorite;
    });
    await DatabaseHelper.instance.updateCarAd(carAd);
  }

  Future<void> _deleteCarAd() async {
    await DatabaseHelper.instance.deleteCarAd(carAd.id!);

    for (var path in imagePaths) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }

    Navigator.pop(context, true);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Usuń ogłoszenie'),
        content: Text('Na pewno chcesz usunąć to ogłoszenie?'),
        actions: [
          TextButton(
            child: Text('Anuluj'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Usuń', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              _deleteCarAd();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
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
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _confirmDelete,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePaths.isNotEmpty)
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) => Image.file(
                      File(imagePaths[index]),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${carAd.brand} ${carAd.model}',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(width: 4),
                        Text(
                          '${carAd.price} zł',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('Rok produkcji: ${carAd.year}'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.speed, size: 18, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('Pojemność silnika: ${carAd.engineCapacity}'),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.speed_outlined, size: 18, color: Colors.grey[700]),
                        SizedBox(width: 8),
                        Text('Przebieg: ${carAd.mileage} km'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Opis:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        carAd.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
