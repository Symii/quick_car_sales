import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/car_ad.dart';
import '../widgets/car_tile.dart';
import 'car_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CarAd>> carAds;

  @override
  void initState() {
    super.initState();
    carAds = DatabaseHelper.instance.getCarAds();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarAd>>(
      future: carAds,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));

        final ads = snapshot.data!;
        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            final ad = ads[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetailsScreen(carAd: ad),
                  ),
                ).then((_) => setState(() {
                  carAds = DatabaseHelper.instance.getCarAds();
                }));
              },
              child: CarTile(carAd: ad),
            );
          },
        );
      },
    );
  }
}
