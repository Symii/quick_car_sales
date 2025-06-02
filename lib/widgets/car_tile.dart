import 'dart:io';
import 'package:flutter/material.dart';
import '../models/car_ad.dart';

class CarTile extends StatelessWidget {
  final CarAd carAd;
  final String? firstImagePath;

  CarTile({required this.carAd, this.firstImagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            child: firstImagePath != null
                ? Image.file(
              File(firstImagePath!),
              fit: BoxFit.cover,
            )
                : Container(
              color: Colors.grey[300],
              child: Icon(Icons.car_repair, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${carAd.brand} ${carAd.model} ${carAd.engineCapacity}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${carAd.mileage} km • ${carAd.year}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${carAd.price} zł',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}