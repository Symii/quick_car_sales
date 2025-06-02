import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/car_ad.dart';
import '../models/car_image.dart';
import '../widgets/car_tile.dart';
import 'car_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<CarAd>> favoriteAds;

  @override
  void initState() {
    super.initState();
    favoriteAds = loadFavorites();
  }

  Future<List<CarAd>> loadFavorites() async {
    final allAds = await DatabaseHelper.instance.getCarAds();
    return allAds.where((ad) => ad.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Obserwowane'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<CarAd>>(
        future: favoriteAds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final ads = snapshot.data!;
          if (ads.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/empty_state_red.jpg',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Brak obserwowanych ogłoszeń.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
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
                      ).then((_) => setState(() {
                        favoriteAds = loadFavorites();
                      }));
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
