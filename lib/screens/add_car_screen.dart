import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../models/car_ad.dart';
import '../models/car_image.dart';
import 'success_screen.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  String brand = '';
  String model = '';
  String year = '';
  String engineCapacity = '';
  String mileage = '';
  String price = '';
  String description = '';
  List<File> imageFiles = [];

  final List<String> availableBrands = ['Abarth', 'Acura', 'Alfa Romeo', 'Alpina', 'Alpine', 'Aston Martin', 'Audi', 'Bentley', 'BMW', 'Bugatti', 'Buick', 'BYD', 'Cadillac', 'Changan', 'Chery', 'Chevrolet', 'Chrysler', 'Citroën', 'Cupra', 'Dacia', 'Daewoo', 'Daihatsu', 'Dodge', 'DS Automobiles', 'Ferrari', 'Fiat', 'Fisker', 'Ford', 'Geely', 'Genesis', 'GMC', 'Great Wall', 'Haval', 'Honda', 'Hummer', 'Hyundai', 'Infiniti', 'Isuzu', 'Iveco', 'Jaguar', 'Jeep', 'Kia', 'Koenigsegg', 'Lada', 'Lamborghini', 'Lancia', 'Land Rover', 'Lexus', 'Lincoln', 'Lotus', 'Lucid', 'Maserati', 'Maybach', 'Mazda', 'McLaren', 'Mercedes-Benz', 'Mercury', 'MG', 'Mini', 'Mitsubishi', 'Nissan', 'Opel', 'Pagani', 'Peugeot', 'Polestar', 'Pontiac', 'Porsche', 'Proton', 'Ram', 'Renault', 'Rolls-Royce', 'Rover', 'Saab', 'Saturn', 'Scion', 'Seat', 'Škoda', 'Smart', 'SsangYong', 'Subaru', 'Suzuki', 'Tata', 'Tesla', 'Toyota', 'Vauxhall', 'Volkswagen', 'Volvo', 'Wiesmann', 'Zastava', 'Żuk'];

  final List<String> availableYears = List.generate(40, (index) {
    final year = DateTime.now().year - index;
    return year.toString();
  });

  final List<String> availableEngineCapacities = ['0.8L', '1.0L', '1.2L', '1.3L', '1.4L', '1.5L', '1.6L', '1.8L', '2.0L', '2.2L', '2.3L', '2.4L', '2.5L', '2.7L', '3.0L', '3.2L', '3.5L', '4.0L', '4.2L', '4.4L', '4.6L', '5.0L', '5.2L', '6.0L', '6.2L', '6.5L', '7.0L', '8.0L'];


  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        imageFiles = pickedFiles.map((e) => File(e.path)).toList();
      });
    }
  }

  void saveAd() async {
    if (_formKey.currentState!.validate() && imageFiles.isNotEmpty) {
      _formKey.currentState!.save();

      final newAd = CarAd(
        brand: brand,
        model: model,
        year: year,
        engineCapacity: engineCapacity,
        mileage: mileage,
        price: price,
        description: description,
      );

      final adId = await DatabaseHelper.instance.insertCarAd(newAd);

      List<CarImage> imagesToInsert = imageFiles.map((file) {
        return CarImage(
          id: null,
          carAdId: adId,
          imagePath: file.path,
        );
      }).toList();

      await DatabaseHelper.instance.insertCarImages(imagesToInsert);

      final insertedAd = await DatabaseHelper.instance.getCarAdById(adId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(carAd: insertedAd!),
        ),
      );
    } else if (imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dodaj przynajmniej jedno zdjęcie!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nowe ogłoszenie')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: imageFiles.isEmpty
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700])
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageFiles.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(imageFiles[index], fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Marka'),
                items: availableBrands
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (v) => setState(() => brand = v ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Wybierz markę' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                validator: (v) => v!.isEmpty ? 'Podaj model' : null,
                onSaved: (v) => model = v!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Rok produkcji'),
                items: availableYears
                    .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                    .toList(),
                onChanged: (v) => setState(() => year = v ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Wybierz rok' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Pojemność silnika'),
                items: availableEngineCapacities
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => engineCapacity = v ?? ''),
                validator: (v) => v == null || v.isEmpty ? 'Wybierz pojemność' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Przebieg (km)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Podaj przebieg';
                  final parsed = int.tryParse(v);
                  if (parsed == null) return 'Podaj poprawny przebieg';
                  if (parsed < 0) return 'Przebieg musi być liczbą dodatnią';
                  return null;
                },
                onSaved: (v) => mileage = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cena (zł)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Podaj cenę';
                  if (double.tryParse(v) == null) return 'Podaj poprawną cenę';
                  return null;
                },
                onSaved: (v) => price = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Opis'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Podaj opis' : null,
                onSaved: (v) => description = v!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveAd,
                child: Text('Dodaj ogłoszenie'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
