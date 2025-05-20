import 'package:flutter/material.dart';
import 'package:pptm_4/models/clothes_detail_model.dart';
import 'package:pptm_4/pages/homepage.dart';
import 'package:pptm_4/services/clothes_service.dart';

class AddClothes extends StatefulWidget {
  const AddClothes({super.key});

  @override
  State<AddClothes> createState() => _AddClothesState();
}

class _AddClothesState extends State<AddClothes> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _sold = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _material = TextEditingController();

  Future<void> addClothes(BuildContext context) async {
    try {
      if (_name.text.trim().isEmpty ||
          _price.text.trim().isEmpty ||
          _category.text.trim().isEmpty ||
          _brand.text.trim().isEmpty ||
          _sold.text.trim().isEmpty ||
          _rating.text.trim().isEmpty ||
          _stock.text.trim().isEmpty ||
          _year.text.trim().isEmpty ||
          _material.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua field wajib diisi 😠")),
        );
        return;
      }

      double? rating = double.tryParse(_rating.text) ?? -1;
      int? year = int.tryParse(_year.text) ?? 0;

      if (  rating < 0 || rating > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rating must be between 0 and 5")),
        );
        return;
      }

      if (year < 2018 || year > 2025) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Release year must be between 2018 and 2025"),
          ),
        );
        return;
      }

      ClothesDetailData newClothes = ClothesDetailData(
        name: _name.text,
        price: int.parse(_price.text),
        category: _category.text,
        brand: _brand.text,
        sold: int.parse(_sold.text),
        rating: double.parse(_rating.text),
        stock: int.parse(_stock.text),
        yearReleased: int.parse(_year.text),
        material: _material.text,
      );

      final response = await ClothesApi.addClothes(newClothes);

      if (response['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clothes added successfully!')),
        );
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Homepage()));
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Clothes"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _price,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              TextField(
                controller: _category,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: _brand,
                decoration: const InputDecoration(labelText: "Brand"),
              ),
              TextField(
                controller: _sold,
                decoration: const InputDecoration(labelText: "Sold"),
              ),
              TextField(
                controller: _rating,
                decoration: const InputDecoration(labelText: "Rating"),
              ),
              TextField(
                controller: _stock,
                decoration: const InputDecoration(labelText: "Stock"),
              ),
              TextField(
                controller: _year,
                decoration: const InputDecoration(labelText: "Year Released"),
              ),
              TextField(
                controller: _material,
                decoration: const InputDecoration(labelText: "Material"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => addClothes(context),
                child: const Text("Add Clothes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
