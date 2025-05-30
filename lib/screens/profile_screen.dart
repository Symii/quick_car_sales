import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    final prof = await DatabaseHelper.instance.getUserProfile();
    if (prof != null) {
      setState(() {
        _nameController.text = prof.name;
        _surnameController.text = prof.surname;
        _addressController.text = prof.address;
        _emailController.text = prof.email;
      });
    }
  }

  void saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final newProfile = UserProfile(
        name: _nameController.text,
        surname: _surnameController.text,
        address: _addressController.text,
        email: _emailController.text,
      );
      await DatabaseHelper.instance.updateUserProfile(newProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil zapisany!')),
      );

      // Odśwież profile po zapisie
      loadProfile();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konto')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Imię'),
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Nazwisko'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Adres'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveProfile,
                child: Text('Zapisz'),
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
