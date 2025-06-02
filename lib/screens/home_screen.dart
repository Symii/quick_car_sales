import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/car_ad.dart';
import '../models/car_image.dart';
import '../widgets/car_tile.dart';
import 'car_details_screen.dart';
import 'add_car_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CarAd>> carAds;

  @override
  void initState() {
    super.initState();
    _loadCarAds();
  }

  void _loadCarAds() {
    setState(() {
      carAds = DatabaseHelper.instance.getCarAds();
    });
  }

  Future<void> _navigateToAddCarScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCarScreen()),
    );
    if (result == true) {
      _loadCarAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ogłoszenia'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddCarScreen,
          ),
        ],
      ),
      body: FutureBuilder<List<CarAd>>(
        future: carAds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final ads = snapshot.data ?? [];

          if (ads.isEmpty) {
            return Center(child: Text('Brak ogłoszeń'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];

              return FutureBuilder<List<CarImage>>(
                future: DatabaseHelper.instance.getCarImages(ad.id!),
                builder: (context, imageSnapshot) {
                  String? firstImagePath;
                  if (imageSnapshot.hasData && imageSnapshot.data!.isNotEmpty) {
                    firstImagePath = imageSnapshot.data!.first.imagePath;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailsScreen(carAd: ad),
                        ),
                      ).then((value) {
                        if (value == true) {
                          _loadCarAds();
                        }
                      });
                    },
                    child: CarTile(carAd: ad, firstImagePath: firstImagePath),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
