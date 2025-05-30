import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../models/car_ad.dart';

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
  File? imageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  void saveAd() async {
    if (_formKey.currentState!.validate() && imageFile != null) {
      _formKey.currentState!.save();

      final newAd = CarAd(
        brand: brand,
        model: model,
        year: year,
        engineCapacity: engineCapacity,
        mileage: mileage,
        price: price,
        description: description,
        imagePath: imageFile!.path,
      );

      await DatabaseHelper.instance.insertCarAd(newAd);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wypełnij wszystkie pola i dodaj zdjęcie!')),
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
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: imageFile == null
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700])
                      : Image.file(imageFile!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Marka'),
                validator: (v) => v!.isEmpty ? 'Podaj markę' : null,
                onSaved: (v) => brand = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Model'),
                validator: (v) => v!.isEmpty ? 'Podaj model' : null,
                onSaved: (v) => model = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Rok produkcji'),
                validator: (v) => v!.isEmpty ? 'Podaj rok' : null,
                onSaved: (v) => year = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Pojemność silnika'),
                validator: (v) => v!.isEmpty ? 'Podaj pojemność' : null,
                onSaved: (v) => engineCapacity = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Przebieg'),
                validator: (v) => v!.isEmpty ? 'Podaj przebieg' : null,
                onSaved: (v) => mileage = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cena'),
                validator: (v) => v!.isEmpty ? 'Podaj cenę' : null,
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
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
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
